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
    self.nextthink = time + self.respawntime;
    break;
  }
  default : {
    RespawnItemDo();
    break;
  }
  }
}

void() PickupItem ={
 //case (self.flags)
}

void() UseItemDo = {};

void() UseItemTry = {
  //prompt flag
  UseItemDo();
}

#define ISITEM {\
  nextthink = time + 0.3;\
  think = RespawnItemTry;\
  modelindex = 0;\
}
#define ISUSABLE {\
  touch = UseItemTry;\
  ISITEM\
}
#define ISCONSUMABLE {\
  use = PickupItem;\
  ISUSABLE\
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
  self.use = PickupItem;
  IsUsable();
};
