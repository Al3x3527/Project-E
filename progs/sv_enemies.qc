float BIPED_DONTRESPAWN = INHIBIT_RESPAWN;
float BIPED_SPAWNED = SPAWNED_ACTIVE;

void() spawn_corpse = {
  entity corpse = spawn();
  setmodel(corpse, self.model);
  setorigin(corpse, self.origin);
  corpse.angles = self.angles;
  corpse.frame = self.frame;
};

void(float behavior) dothink = {
  field_t thinkField = entityfieldref(behavior);
  other.think = other.thinkField;
  if !(other.think) return;
  other.nextthink = time + 0.1;
}
void() stand = {dothink(findentityfield("th_stand"));};
void() die = {dothink(findentityfield("th_die"));};
void() walk = {dothink(findentityfield("th_walk"));};
void() run = {dothink(findentityfield("th_run"));};
void() pain = {dothink(findentityfield("th_pain"));};
void() charge = {dothink(findentityfield("th_charge"));};
void() evade = {dothink(findentityfield("th_evade"));};
void() grenade = {dothink(findentityfield("th_grenade"));};
void() crouch = {dothink(findentityfield("th_crouch"));};


//void() tactical = {other.think = tacthink; other.nextthink = time + 0.1;}

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
  void() tracked_c = {
    refzero = findentityfield("prop0");
  };
};

.string step0; //like targetn
.string step1;
.string step2;
.string step3;
.string step4;
.string step5;
.string step6;
.string step7;
.string targetcmdlist;
class cmdlist_c : entity {
  float refzero;
  float step;
  tracked_c cmdtracked;

virtual void() cmduse = {
  //this = cmdlist, other = biped
  if (this.step > (this.refzero + 7)) return; //no more steps
  //dprint(other.classname); dprint(" cmduse\n");
  field_t stepField = entityfieldref(this.step);
  string stepn = stepField;
  if (isfunction(stepn)) callfunction(stepn);
  //else {dprint(stepn); dprint(" is not a function\n");}
  this.step ++;
};

 virtual void(entity inflictor, float damage) th_pain = {
   this.enemy = inflictor;
   dprint(this.enemy.classname); dprint(" cmd ememy\n");
   tracked_c tracked = this.cmdtracked;
   float ref = tracked.refzero;
   float zero = ref;
   field_t currentf = entityfieldref(ref);
   entity trackent = tracked.currentf;
   while (trackent) {
     ref ++;
     currentf = entityfieldref(ref);
     if (ref > (zero + 19)) {dprint("full cmd list\n"); return;}
     trackent = tracked.currentf;
   }
   tracked.currentf = inflictor;
 };
 //prop list?

  void() cmdlist_c = {
    fgdprint("@fgd @baseclass = cmdlist : command list designed in editor. [");
    fgdprint("@fgd step(int) : command list step index");
    fgdprint("@fgd step0(string) : target controller: up tp step7");
    fgdprint("@fgd ]");
    dprint(this.targetname);dprint(" command list spawn\n");
    dprint(step0); dprint(" step0\n");
    step = refzero = findentityfield("step0");
    dprint(ftos(entityfieldtype(this.step))); dprint(" step0 field type\n"); //1 str 2 fl
    classname = "commandlist";
    if !(step) dprint("field ref failed\n");
    else {dprint(ftos(step)); dprint ("step0 ref\n");}
    use = cmduse;
    dprint(step0); dprint(" is step0\n");
    cmdtracked = spawn(tracked_c);
  };
};

.cmdlist_c commandlist;

class enemylist_c : entity {
  float refzero;
  entity foe0;
  entity foe1;
  entity foe2;
  entity foe3;

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
  //string targetcmdlist;
  //cmdlist_c commandlist;
  firingpoint_c firingpoint;
  string firinggroup;

nonvirtual void() StateMachineGo = {};

nonvirtual void() RespawnBipedDo = { //walkmonster start, do
  setmodel(this, this.model);
  this.solid = SOLID_SLIDEBOX;
  this.movetype = MOVETYPE_STEP;
  this.flags += FL_MONSTER;
  droptofloor();
  if (!walkmove(0,0)){dprint(this.classname);dprint("stuck at ");dprint(vtos(this.origin));dprint("\n");}

  this.think = StateMachineGo;
  this.nextthink = time + 0.3;
  //dprint("respawn biped do\n");
  this.commandlist = findcmdlist(this.targetcmdlist);
  if(this.commandlist) this.commandlist.th_pain(this,0);
  else {dprint(this.targetcmdlist);dprint("no command list\n");}
  this.enemies = spawn(enemylist_c);
  this.tracked = spawn(tracked_c);
};

nonvirtual void() RespawnBipedTry = {
  switch (this.spawnflags) {
    case BIPED_DONTRESPAWN : {
      this.think = sub_noop;
      break;
    }
  case BIPED_SPAWNED : {
    //if checkruntime() RespawnItemDo; else - clear behavior
    if (this.runtime_current < this.runtime_minimum) {
      RespawnBipedDo();
      this.runtime_current += 1;
      break;
    }
    else {
    this.nextthink = time + this.respawntime;
    break;
    }
  }
  default : {
    if !(this.runtime_maximum) {
        RespawnBipedDo();
        this.runtime_current += 1;
        break;
      }
    if (this.runtime_current < this.runtime_maximum) {
      RespawnBipedDo();
      this.runtime_current += 1;
      break;
    }
    else {
      this.nextthink = time + this.respawntime;
      break;
    }
  }
  }
};

 nonvirtual void() DespawnBiped = {
  this.health = 0;
  remove(this);
 };

 nonvirtual void() IsSpawner = {
  this.nextthink = time + 0.3;
  this.think = RespawnBipedTry;
  this.modelindex = 0;
  //dprint("is spawner\n");
 };

 nonvirtual void() IsAlive = {
  //dprint("is alive\n");
  if (this.spawnflags & BIPED_SPAWNED) return;
  IsSpawner();
 };


 void() biped_class = {
    FGDbase(Spawnflags Targetname);
    COLOR();
    think = IsAlive;
    //dprint("biped spawn function\n");
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

//class player_class : entity = {
//  void() player_class = {
//    currentgame.basictraits();
//  };
//};

