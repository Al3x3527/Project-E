float BIPED_DONTRESPAWN = INHIBIT_RESPAWN;
float BIPED_SPAWNED = SPAWNED_ACTIVE;

class cmdlist_c : entity {
  int step;
  string step0; //like targetn
  string step1;
  string step2;
  string step3;
  string step4;
  string step5;
  string step6;
  string step7;

nonvirtual string (int i) cmdindex = {
    //use entityfieldref instead? float step current fieldref?
    switch (i) {
      case 0 : return(step0);
      case 1 : return(step1);
      case 2 : return(step2);
      case 3 : return(step3);
      case 4 : return(step4);
      case 5 : return(step5);
      case 6 : return(step6);
      case 7 : return(step7);
      default: return(__NULL__);
      }
};
  void() cmdlist_c = {
    fgdprint("@fgd @baseclass = cmdlist : command list designed in editor. [");
    fgdprint("@fgd step(int) : command list step index");
    fgdprint("@fgd step0(string) : target controller: up tp step7");
    fgdprint("@fgd ]");

    step = findentityfield("step0");
  };
};

class tracked_c : entity {
  float refzero;
  entity prop0;
  entity prop1;
  entity prop2;
  entity prop3;
  entity prop4;
  entity prop5;
  entity prop6;
  entity prop7;
  entity prop8;
  entity prop9;
  entity prop10;
  entity prop11;
  entity prop12;
  entity prop13;
  entity prop14;
  entity prop15;
  entity prop16;
  entity prop17;
  entity prop18;
  entity prop19;
  nonvirtual entity (int i) propindex = {
    //float propref prop0 ref?
    switch (i) {
      case 0 : return(prop0);
      case 1 : return(prop1);
      case 2 : return(prop2);
      case 3 : return(prop3);
      case 4 : return(prop4);
      case 5 : return(prop5);
      case 6 : return(prop6);
      case 7 : return(prop7);
      case 8 : return(prop8);
      case 9 : return(prop9);
      case 10 : return(prop10);
      case 11 : return(prop11);
      case 12 : return(prop12);
      case 13 : return(prop13);
      case 14 : return(prop14);
      case 15 : return(prop15);
      case 16 : return(prop16);
      case 17 : return(prop17);
      case 18 : return(prop18);
      case 19 : return(prop19);
      default : return(world);
    }
  };
  void() tracked_c = {
    refzero = findentityfield("prop0");
  };
};

class enemylist_c : entity {
  float refzero;
  entity foe0;
  entity foe1;
  entity foe2;
  entity foe3;
  nonvirtual entity(int i) enemyindex = {
    switch (i) {
      case 0: return(foe0);
      case 1: return(foe1);
      case 2: return(foe2);
      case 3: return(foe3);
      default: return(world);
    }
  };
  void() enemylist_c = {
    refzero = findentityfield("foe0");
  };
};
cmdlist_c (string search) findcmdlist = {return(find(world, targetname, search));};

class firingpoint_c : entity {
  void() firingpoint_c = {

  };
};

class zone_c : entity {
  float refzero;
  firingpoint_c point0;
  firingpoint_c point1;
  firingpoint_c point2;
  firingpoint_c point3;
  firingpoint_c point4;
  firingpoint_c point5;
  firingpoint_c point6;
  firingpoint_c point7;
  firingpoint_c point8;
  firingpoint_c point9;
  firingpoint_c point10;
  firingpoint_c point11;
  firingpoint_c point12;
  firingpoint_c point13;
  firingpoint_c point14;
  firingpoint_c point15;
  void() zone_c = {
    refzero = findentityfield("point0");
  };
};

class biped_class : entity { //biped spawn point definition
  enemylist_c enemies;
  tracked_c tracked;
  //squad_c squad;
  float traitor;
  entity leader;
  float control;
  float action;
  //float status;
  //objective_c objective;
  string targetcmdlist;
  cmdlist_c commandlist;
  firingpoint_c firingpoint;
  string firinggroup;

nonvirtual void() StateMachineGo = {};

nonvirtual void() RespawnBipedDo = { //walkmonster start, do
  setmodel(this, this.model);
  this.solid = SOLID_TRIGGER;
  this.think = StateMachineGo;
  this.nextthink = time + 0.3;

  this.commandlist = findcmdlist(this.targetcmdlist);
  this.enemies = spawn(enemylist_c);
  this.tracked = spawn(tracked_c);
};

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
};

void() DespawnBiped = {
  self.health = 0;
  remove(self);
};

void() IsSpawner = {
  self.nextthink = time + 0.3;
  self.think = RespawnBipedTry;
  self.modelindex = 0;
};

void() IsAlive = {
  if (self.spawnflags & BIPED_SPAWNED) return;
  IsSpawner();
};

  void() biped_class = {
    FGDbase(Spawnflags Targetname);
    COLOR();
    think = IsAlive;
    nextthink = time + 0.3;
  };
};

class squad_c : entity {
  //objective_c objective;
  float traitor;
  float strength;
  //platoon_c platoon;
  float squadtype;
  tracked_c tracked;
  float refzero;
  biped_class member0;
  biped_class member1;
  biped_class member2;
  biped_class member3;
  biped_class member4;
  biped_class member5;
  biped_class member6;
  biped_class member7;
  biped_class leader;
  void() squad_c = {
    refzero = findentityfield("member0");
  };
};

class platoon_c : entity {
 // objective_c objective;
  float traitor;
  float refzero;
  squad_c squad0;
  squad_c squad1;
  squad_c squad2;
  squad_c squad3;
  void() platoon_c = {
    refzero = findentityfield("squad0");
  };
};

class objective_c : entity {
  string firinggroup;
  zone_c zone;
  float control;
  float style;
  float type;
  float popcap;
  platoon_c platoon;
  float minstrength;
  cmdlist_c conditions;
  float squadtype;
  void() objective_c = {};
};

BPCLASS(biped_man, "human biped");
ENTMODEL("cubeman.mdl");
ENDCLASS;

//class player_class : entity = {
//  void() player_class = {
//    currentgame.basictraits();
//  };
//};

