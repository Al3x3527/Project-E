void() RespawnItemDo = {
  setmodel(self, self.model);
  self.solid = SOLID_TRIGGER;
}

void() RespawnItemTry = {
  switch (self.spawnflags) {
    case ITEM_DONTRESPAWN : {
      self.think = SUB_NULL;
      break;
    }
  case ITEM_HELD : {
    //if checkruntime() RespawnItemDo; else - clear behavior
    self.nextthink = time + respawntime;
    break;
  }
  case default : {
    RespawnItemDo();
    break;
  }
  }
}

void() PickupItem ={
 //case (self.flags)
}

void() UseItemTry = {
  //prompt flag
  UseItemDo();
}

#define ISITEM {\
  self.nextthink = time + 0.3;\
  self.think = RespawnItemTry;\
  self.modelindex = 0;\
}
#define ISUSABLE {\
  self.touch = UseItemTry;\
  ISITEM\
}
#define ISCONSUMABLE {\
  self.use = PickupItem;\
  ISUSABLE\
}
