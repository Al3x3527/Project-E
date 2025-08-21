void() SUB_NULL = {};
.float respawntime;

void() RespawnItemDo = {
  setmodel(self, self.model);
  self.solid = SOLID_TRIGGER;
}
float ITEM_DONTRESPAWN = 4;
float ITEM_HELD = 8;
void() RespawnItemTry = {
  switch (self.spawnflags) {
    case ITEM_DONTRESPAWN : {
      self.think = SUB_NULL;
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
  this.nextthink = time + 0.3;\
  this.think = RespawnItemTry;\
  this.modelindex = 0;\
}
#define ISUSABLE {\
  this.touch = UseItemTry;\
  ISITEM\
}
#define ISCONSUMABLE {\
  this.use = PickupItem;\
  ISUSABLE\
}
