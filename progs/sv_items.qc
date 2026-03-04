void() RespawnItemDo = {
  setmodel(self, self.model);
  self.solid = SOLID_TRIGGER;
}
float ITEM_DONTRESPAWN = 4;
float ITEM_HELD = 8;
void() RespawnItemTry = {
  switch (self.spawnflags) {
    case ITEM_DONTRESPAWN : {
      self.think = sub_noop;
      break;
    }
  case ITEM_HELD : {
    //if checkruntime() RespawnItemDo; else - clear behavior
    if (self.runtime_current < self.runtime_minimum) {
      RespawnItemDo();
      self.runtime_current += 1;
      break;
    }
    else {
    self.nextthink = time + self.respawntime;
    break;
    }
  }
  default : {
    if !(self.runtime_maximum) {
        RespawnItemDo();
        self.runtime_current += 1;
        break;
      }
    if (self.runtime_current < self.runtime_maximum) {
      RespawnItemDo();
      self.runtime_current += 1;
      break;
    }
    else {
      self.nextthink = time + self.respawntime;
      break;
    }
  }
  }
}

void() DespawnItem = {
  //dprint(self.classname); dprint(" despawned\n");
  self.solid = SOLID_NOT;
  self.modelindex = 0;
}

#define CONSUMEITEM {\
  if(this.spawnflags | ITEM_HELD) return;\
  this.spawnflags = this.enemy.spawnflags -= ITEM_HELD;\
  this.enemy.nextthink = time + this.enemy.respawntime;\
  return;}
/*
void() ConsumeItem = {
  if(self.spawnflags || ITEM_HELD) return;
  self.spawnflags -= ITEM_HELD;
  self.nextthink = time + respawntime;
}*/

void() PickupItem ={
  DespawnItem();
  if (self.spawnflags | ITEM_HELD) self.spawnflags += ITEM_HELD;
  self.equip(); //because we don't know the class
}

void() AutoPickup ={
  self.use();
  sprint(other, 1, strcat("You got the ", self.netname, "\n"));
  DespawnItem();
  if (self.spawnflags | ITEM_HELD) self.spawnflags += ITEM_HELD;
}

void() UseItemDo = {
  //sprint(other, 1, "UseItemDo\n");
  self.use();
};

void() UseItemTry = {
  //prompt flag
  //dprint("UseItemTry\n");
  if (other.impulse == 1) {
    other.impulse = 0;
    UseItemDo();
    return;
    }
  else if (self.impulse > time) return;
  self.impulse = time + 1;
  sprint(other, 1, "press 1 to use\n");
}

void() IsItem = {
  self.nextthink = time + 0.3;
  self.think = RespawnItemTry;
  self.modelindex = 0;
};
void() IsUsable = {
  self.touch = UseItemTry;
  IsItem();
};
void() IsConsumable = {
  if (self.spawnflags & ITEM_HELD) return;
  self.use = PickupItem;
  IsUsable();
};
void() IsAutoPickup = {
  //have their own touch functions
  if (self.spawnflags & ITEM_HELD) return;
  self.touch = AutoPickup;
  IsItem();
};

void(string keyname) keylock_set_custom_key;
void() IsKey = {
  keylock_set_custom_key(self.target);
  IsAutoPickup();
};

void(entity old) drop_weapon; //sv_combat.qc
void(entity item) drop_an_item = {
  other = item.owner;
  //dprint(strcat(vtos(other.origin), " weapon drop origin\n"));
 // item.owner = world;
 // item.solid = SOLID_TRIGGER;
  item.movetype = MOVETYPE_NONE; //why do you fly away? one landed close and acted normal
  //setorigin(item, self.origin);
//  if (item.spawnflags & ITEM_HELD) item.spawnflags -= ITEM_HELD;

  drop_weapon(item);
}
void() drop_items = {
  self.movechain = FALSE;
  entity item;
  if (self.primary) drop_an_item(self.primary);
  if (self.secondary) drop_an_item(self.secondary);
}
