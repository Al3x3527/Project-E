float BIPED_DONTRESPAWN = 4;
float BIPED_SPAWNED = 8;

void() RespawnBipedDo = { //walkmonster start, do
  setmodel(self, self.model);
  self.solid = SOLID_TRIGGER;
}

void() RespawnBipedTry = {
  switch (self.spawnflags) {
    case BIPED_DONTRESPAWN : {
      self.think = sub_noop;
      break;
    }
  case BIPED_SPAWNED : {
    //if checkruntime() RespawnItemDo; else - clear behavior
    if (self.runtime_current < self.runtime_minimum) {
      RespawnBipedDo();
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
        RespawnBipedDo();
        self.runtime_current += 1;
        break;
      }
    if (self.runtime_current < self.runtime_maximum) {
      RespawnBipedDo();
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

void() DespawnBiped = {
  self.health = 0;
  remove(self);
};

void() IsSpawner = {
  self.nextthink = time + 0.3;
  self.think = RespawnBipedTry;
  self.modelindex = 0;
}

void() IsAlive = {
  if (self.spawnflags & BIPED_SPAWNED) return;
  IsSpawner();
};

class biped_class : entity = { //biped spawn point definition
  void() biped_class = {
    FGDbase(Spawnflags Targetname);
    COLOR();
    think = IsAlive;
    nextthink = time + 0.3;
  };
};
