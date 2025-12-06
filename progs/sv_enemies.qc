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
  other.impulse = TRUE;
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

void() usebyname = {
  entity use_ent = find(world, targetname, self.target); //self = cmd?
  use_ent.use();
  other.impulse = TRUE; //other = trigger
};



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
  other.impulse = 0; // to test
  if (this.step > (this.refzero + 7)) return; //no more steps
  //dprint(other.classname); dprint(" cmduse\n");
  field_t stepField = entityfieldref(this.step);
  string stepn = stepField;
  if (isfunction(stepn)) callfunction(stepn);
  //else {dprint(stepn); dprint(" is not a function\n");}
  if (other.impulse) this.step ++;
  other.impulse = FALSE;
};

 virtual void(entity inflictor, float damage) th_pain = {
   this.enemy = inflictor;
   dprint(this.enemy.classname); dprint(" cmd ememy\n");
   tracked_c tracked = this.cmdtracked;
   float ref = tracked.refzero;
   float zero = ref;
 };
 //prop list?

  void() cmdlist_c = {
    fgdprint("@fgd \n@PointClass = cmdlist : \"command list designed in editor.\"\n [");
    fgdprint("@fgd \nstep(int) : \"command list step index\"");
    fgdprint("@fgd \nstep0(string) : \"target controller: up to step7\"");
    //fgdprint("@fgd \nthis is a third statement");
    //fgdprint("@fgd \n ]");
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
  entity foe0;
  entity foe1;
  entity foe2;
  entity foe3;

  void() enemylist_c = {

  };
};
cmdlist_c (string search) findcmdlist = {return(find(world, targetname, search));};


//NOTE path_search moved to sv_combat.qc
float (entity ent) CheckAlive = {
  dprint("check alive\n");
  if (ent.flags & FL_COVER) return (0);
  if !(ent.health > 0) return(0);
  if (ent) return(1);
  return(0);
};

float (entity ent) CheckLine = {dprint("check line\n");
  traceline(self.origin, ent.origin, MOVE_NOMONSTERS, self);
  if (trace_fraction == 1) {
    //if (self.status < STA_SIGHT) self.status = STA_SIGHT;
    return(1);
  }
  //if (self.status > STA_UNCERTAIN) self.status = STA_UNCERTAIN;
  return(0);
};// NOTE: not oo function

entity (float dist) RequestSearch = {
  //dprint("search requested\n");
if (self == searchent) {
  if (time < searchtime + 0.5) return (world);
 }
 else if (CheckDist(searchent) < DIST_FAR)
   if (time < searchtime + 0.25) return (world);
//dprint("request granted\n");
searchent = self;
searchtime = time;
return(findradius(self.origin, dist, searchchain));
}

void() VirtualWeapon;

float (int i, tracked_c test, entity ent) testpropref = {
 field_t checkfield = entityfieldref( findentityfield (strcat (
                                                               "tracked_c::__mprop",
                                                               itos (i))));
 return(ent == test.checkfield);
};

void(int i, tracked_c shift) shiftpropfields = {
  field_t oldfield = entityfieldref( findentityfield (strcat (
                                                              "tracked_c::__mprop",
                                                              itos (i+1))));
  field_t newfield = entityfieldref( findentityfield (strcat (
                                                              "tracked_c::__mprop",
                                                              itos (i))));
  shift.newfield = shift.oldfield;
};

entity(int i, tracked_c test) testpropcover = {
  entity e = self.enemy;
  field_t checkfield = entityfieldref( findentityfield (strcat (
                                                                "tracked_c::__mprop",
                                                                itos (i))));
  entity p = test.checkfield;
  vector vec;
  firingpoint_c temp;
  if (p.flags & FL_CORNER) {
    if !(p.view_ofs) {
        //no ofs test x
        vec = p.origin + '0 16 0';
        //test dir
        traceline(vec, self.origin, 1, self);
        if (trace_fraction != 1) {
          vec = p.origin + '0 -16 0';
        }
        //test line
        traceline(vec, e.origin, 1, self);
        if (trace_fraction == 1) {
          //test y
          vec = p.origin + '16 0 0';
          traceline(vec, self.origin, 1, self);
          if (trace_fraction != 1) {
            vec = p.origin + '-16 0 0';
          }
          traceline (vec, e.origin, 1, self);
        if (trace_fraction == 1) return 0;
        }
      } else{
    //test ofs_x
    vec = p.origin + p.view_ofs_x * '1 0 0';
    traceline(vec, e.origin, 1 ,self);
    if (trace_fraction == 1) {
    //test ofs_y
      vec = p.origin + p.view_ofs_y * '0 1 0';
      traceline(vec, e.origin, 1, self);
      if (trace_fraction == 1) return (FALSE);
    }
    }
  }
  else {
    if (p.flags | FL_COVER) return (FALSE);
    vec = p.origin - e.origin;
    vector offset = p.maxs - p.mins;
    vec += normalize(vec) * (offset * vec) * 1.1;
    traceline(vec, e.origin, 1, self);
    if (trace_fraction == 1) return (FALSE);
  }
  temp = spawn(firingpoint_c);
  setorigin(temp, vec);
  temp.nextthink = time + 15;
  temp.flags = FL_COVER;
  return (temp);
}

class biped_class : entity { //biped spawn point definition
  enemylist_c enemies; //4
  tracked_c tracked; //20
  //squad_c squad;
  int traitor;
  entity leader;
  int control;
  int action;
  int status;
  float strength;
  //objective_c objective;
  //string targetcmdlist;
  //cmdlist_c commandlist;
  entity firingpoint; //NOTE: not guaranteed firingpoint_c
  string firinggroup;

nonvirtual float (entity ent) addprop = {
  int i = 0;
  //check for open field
  while (i < 20) {
    if (testpropref(i, this.tracked, ent)) return(1);
    i++;
  }
  //shift prop fields
  i = 0;
  while (i < 19) {
    shiftpropfields(i, this.tracked);
    i++;
  }
  this.tracked.prop19 = ent;
  return (1);
};

nonvirtual float (entity ent) addenemy = {
  entity least = ent;
  if !(this.enemies) this.enemies = spawn(enemylist_c);

  if !(this.enemies.foe0) this.enemies.foe0 = ent;
  else {
    if (this.enemies.foe0 == ent) return(0);
    if (this.enemies.foe0.scary < least.scary) least = this.enemies.foe0;
    if !(this.enemies.foe1) this.enemies.foe1 = ent;
    else {
      if (this.enemies.foe1 == ent) return(0);
      if (this.enemies.foe1.scary < least.scary) least = this.enemies.foe1;
      if !(this.enemies.foe2) this.enemies.foe2 = ent;
      else {
        if (this.enemies.foe2 == ent) return(0);
        if (this.enemies.foe2.scary < least.scary) least = this.enemies.foe2;
        if !(this.enemies.foe3) this.enemies.foe3 = ent;
        else {
          if (this.enemies.foe3 == ent) return(0);
          if (this.enemies.foe3.scary < least.scary) least = this.enemies.foe3;
        }
      }
    }
  }
  if (least == ent) {
    addprop(ent);
    return(0);
  }
  if !(this.enemy) this.enemy = ent;
  if (this.enemies.foe0 == least) this.enemies.foe0 = ent;
  else if (this.enemies.foe1 == least) this.enemies.foe1 = ent;
  else if (this.enemies.foe2 == least) this.enemies.foe2 = ent;
  else if (this.enemies.foe3 == least) this.enemies.foe3 = ent;
  else dprint("problem in addenemy!\n");
  dprint("enemy found\n");
  return (1);
};

nonvirtual float () findfear = {
  entity ent = this.enemy;
  vector sdanger = this.scary * '1 0 0' + this.movechain.scary * '0 1 0';
  vector odanger = ent.scary * '1 0 0' + ent.movechain.scary * '0 1 0';
  float fear = vlen(odanger - sdanger);

  return(fear > 0);
};

 nonvirtual float () findcover = {
   // test FL_COVER props against enemy, create firingpoint_c
   entity coverpoint;
   tracked_c test = this.tracked;
   int i = 0;
   while (i < 20) {
     coverpoint = testpropcover(i, test);
     if (coverpoint) {
       this.goalentity = coverpoint;
       return(1);
     }
     i++;
   }
   return(0);
 };

 nonvirtual void() find_status = { //fallback
    entity e;
    int dist;
    if (this.goalentity){ //active
      if (this.enemy) { //combat
        e = this.enemy;
        dist = CheckDist(e);
        if (dist < DIST_FAR) { //uncertain
          if (CheckLine(e)) { //sight
            if (dist < DIST_MED) { //near
              if (dist < DIST_NEAR) { //krieg
               this.status = STA_KRIEG;
              } else this.status = STA_NEAR;
            } else this.status = STA_SIGHT;
          } else this.status = STA_UNCERTAIN; //may search here, may be certain
        } else this.status = STA_COMBAT; //may search here
      } else this.status = STA_ACTIVE;
    } else this.status = STA_IDLE;
  }; //TODO: access searching, certain by message
     //NOTE: in weaponsound

 nonvirtual void() find_action = { //fallback
   if (this.control & this.action) this.action = ACT_NONE;
   //NOTE: ACT_WAIT, ACT_UNCOVER, ACT_NONE never supressed
   if !(this.status) {
     if !(this.action) return;
     if (this.action == ACT_SLEEP) return; //by message
     this.action = ACT_NONE;
     this.think = this.th_stand;
     return;
     //alert by message
   }
   if (this.status < 2) {
     if (this.action == ACT_WAIT) return;
     this.action = ACT_WAIT;
     this.think = this.th_wait;
     return;
     //converse by message
     //alert by message
   }
   if (this.status == 2) {
     if (this.action == ACT_GUARD) return;
     if (this.action == ACT_WAIT) return;
     if (this.action == ACT_VEHICLE) return; //by message
     if (this.action == ACT_OBEY) return; //by message
     if (this.firingpoint && (this.control | ACT_GUARD)) {
       this.action = ACT_GUARD;
       this.think = this.th_run;
       return;
     }
     this.action = ACT_WAIT;
     this.think = this.th_wait;
     return;
     //alert by message
   }
   if (this.status == 3) {
     if (this.action == ACT_GUARD) return;
     if (this.action == ACT_WAIT) return;
     if (this.action == ACT_VEHICLE) return;
     if (this.action == ACT_CHARGE) return;
     if (this.action == ACT_OBEY) return;
     if (this.action == ACT_AVOID) {
       this.action = ACT_UNCOVER;
       this.think = this.th_uncover;
       return;
     }
     if ((this.strength < 0.5) && (this.control | ACT_CHARGE)) {
       //character of think by class
       //ineffectual rage
       this.action = ACT_CHARGE;
       this.think = this.th_charge;
     }
     if (this.firingpoint && (this.control | ACT_GUARD)) {
       this.action = ACT_GUARD;
       this.think = this.th_guard;
       return;
     }
     this.action = ACT_WAIT;
     this.think = this.th_wait;
     return;
   }
   if (this.status == 4) {
     if (this.action == ACT_SEARCH) return;
     if (this.action == ACT_OBEY) return;
     this.action = ACT_SEARCH;
     this.think = this.th_search;
     return;
     //alert by message
     //uncover by message
   }
   if (this.action == ACT_FIGHT) return;
   if (this.action == ACT_FLEE) return;
   if (this.action == ACT_GUARD) return;
   if (this.action == ACT_CHARGE) return;
   if (this.status < 7) {
     if (this.action == ACT_WAIT) return;
     if (this.action == ACT_VEHICLE) return;
     if (this.action == ACT_OBEY) return;
     if ((this.control | ACT_FLEE) && findfear()) {
       this.action = ACT_FLEE;
       this.think = th_flee;
       return;
     }
     if ((this.control | ACT_CHARGE) && (this.strength < 0.5)) {
       this.action = ACT_CHARGE;
       this.think = this.th_charge;
       return;
     }
     if ((this.control | ACT_GUARD) && this.firingpoint) {
       this.action = ACT_GUARD;
       this.think = this.th_guard;
       return;
     }
     if (this.control | ACT_FIGHT) {
       this.action = ACT_FIGHT;
       this.think = this.th_run;
       return;
       }
     this.action = ACT_WAIT;
     this.think = this.th_wait;
     return;
   }
   if ((this.action == ACT_VEHICLE) && (this.owner.flags & FL_VEHICLE)) return;
   if (this.action == ACT_AVOID) return;
   if (this.action == ACT_CHARGE) return;
   if (this.status == 7) {
     if ((this.control | ACT_CHARGE) && (this.strength < 0.5)) {
       this.action = ACT_CHARGE;
       this.think = this.th_charge;
       return;
     }
     if ((this.control | ACT_FLEE) && findfear()) {
       this.action = ACT_FLEE;
       this.think = this.th_flee;
       return;
     }
     if ((this.control | ACT_GUARD) && this.firingpoint) {
       this.action = ACT_GUARD;
       this.think = this.th_guard;
       return;
     }
     if (this.control | ACT_FIGHT) {
       this.action = ACT_FIGHT;
       this.think = this.th_run;
       return;
       }
     this.action = ACT_WAIT;
     this.think = this.th_wait;
     return;
   }
   if ((this.control | ACT_AVOID) && findcover()) {
     this.action = ACT_AVOID;
     this.think = this.th_avoid;
     return;
   }
   if ((this.control | ACT_CHARGE) && this.strength < 0.5) {
     this.action = ACT_CHARGE;
     this.think = this.th_charge;
     return;
   }
   if ((this.control | ACT_FLEE) && findfear()) {
     this.action = ACT_FLEE;
     this.think = this.th_flee;
     return;
   }
   if ((this.control & ACT_GUARD) && this.firingpoint) {
     this.action = ACT_GUARD;
     this.think = this.th_guard;
     return;
   }
   if (this.control | ACT_FIGHT) {
     this.action = ACT_FIGHT;
     this.think = this.th_run;
     return;
     }
   this.action = ACT_WAIT;
   this.think = this.th_wait;
 };

//nonvirtual void() StateMachineGo = {};
nonvirtual void() findstuff = {
  entity ent = this;
  float entyaw;
  float thisyaw = vectoyaw(this.angles) + 90;
  float maxyaw = 70;
  float deltayaw;
  float dist = 500;
  //dprint("find stuff\n");
  ent = RequestSearch(dist);
  if !(ent) return;
  while (ent) {
    if (ent.flags & FL_SEARCHPOINT) { //else real
      if !(CheckLine(ent.enemy)) { //visible ignore
          if (CheckAlive(ent)) {//prop ignore
            if (ent.team != this.team) { //ignore
              addenemy(ent);
              if (this.status < STA_CERTAIN) this.status = STA_CERTAIN;
              } //team ignore
            } //prop ignore
        }
    } else{ //real
      //dprint("real found\n");
      if (CheckLine(ent)) { //else check path
        if (CheckAlive(ent)) { //see prop
          if (ent.team != this.team) { //ignore
            //dprint("potential enemy found\n");
            entyaw = vectoyaw (ent.origin - this.origin);
            deltayaw = fabs(thisyaw - entyaw);
            if (deltayaw > 180) deltayaw -= 180;
            if (deltayaw < maxyaw) { //ignore
              addenemy(ent);
              if (this.status < STA_SIGHT) this.status = STA_SIGHT;
            }
          }
      } else {
         addprop(ent);
        }
      } else { //always see path entities
        if (ent.flags & FL_COVER) {
          addprop(ent);
        }
      }
    }
    ent = ent.searchchain;
  }
};

nonvirtual void() findgoal = {
  dprint("findgoal\n");
  if (this.goalentity) return;
  this.goalentity = findtarget(this.firinggroup);
  if (this.goalentity) this.firingpoint = this.goalentity;
  else this.goalentity = findtarget(this.target);
  if (this.goalentity){
    this.action = ACT_GUARD;
    this.status = STA_ACTIVE;
    this.think = th_walk;
    dprint("found goal\n");
  }
  else dprint("no goal found\n");
};

nonvirtual void() ai_idle = {
  //dprint("ai_idle\n");
  if !(this.action) return; //actually return
  if (this.status & STA_IDLE) {
    findstuff();
    if (this.enemy) this.think = this.th_charge;
    return;
  } //look for enemies
  if !(this.firingpoint) findgoal();
};

nonvirtual void(float dist) ai_walk = {
  findstuff();
  if (this.enemy) this.think = this.th_charge;
  if !(this.goalentity) this.think = this.th_stand;
  this.ideal_yaw = vectoyaw(this.goalentity.origin - this.origin);
  sub_changeyaw();
  movetogoal(dist);
};

nonvirtual void(float dist) ai_charge = {
  if !(this.enemy) {
    this.think = this.th_stand;
    //check tracked
    this.status = STA_COMBAT;
    return;
  }
  this.goalentity = this.enemy;
  if (this.enemy.flags != FL_SEARCHPOINT)
    if (CheckLine(this.enemy)) {
      this.status = STA_SIGHT;
      this.enemy.lastseen = this.enemy.origin; //new update lastseen
      }
    else {
      this.status = STA_UNCERTAIN;
      //searchpoint at enemy.lastseen
      entity old = this.enemy;
      path_search new = spawn(path_search);
      this.enemy = new;
      new.lastseen = old.lastseen;
      setorigin(new, old.lastseen);
      new.enemy = old;
      }
  this.ideal_yaw = vectoyaw(this.enemy.origin - this.origin);
  sub_changeyaw();
  movetogoal(dist);
  if (this.status > STA_CERTAIN) //TODO: other attacks
    if (random() > 0.8)
      this.think = this.th_shoot;
};

nonvirtual void() ai_shoot = {
  this.weapon_use();
};

nonvirtual void() RespawnBipedDo = { //walkmonster start, do
  setmodel(this, this.model); //TODO set model index instead
  setsize(this, '-16 -16 0', '16 16 80'); //TODO make universal
  this.solid = SOLID_SLIDEBOX;
  this.movetype = MOVETYPE_STEP;
  this.flags += FL_MONSTER + FL_ONGROUND;
  setorigin(this, this.origin + '0 0 0');
  droptofloor();
  if (!walkmove(0,0)){dprint(this.classname);dprint("stuck at ");dprint(vtos(this.origin));dprint("\n");}

  this.think = this.th_stand;
  this.nextthink = time + 0.1;
  //this.think = StateMachineGo;
  //this.nextthink = time + 0.3;
  //dprint("respawn biped do\n");
  this.commandlist = findcmdlist(this.targetcmdlist);
  if(this.commandlist) this.commandlist.th_pain(this,0);
  else {dprint(this.targetcmdlist);dprint("no command list\n");}
  this.enemies = spawn(enemylist_c);
  this.tracked = spawn(tracked_c);

  if(this.weapon) VirtualWeapon();
  //if !(this.squad) this.squad = spawn(squad_c);
  //this.squad.style = this.style + FL_NOSQUAD; in spawn function
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
  //if (this.spawnflags & BIPED_SPAWNED) return;
  IsSpawner();
 };


 void() biped_class = {
    FGDbase("Spawnflags, Targetname", biped_class, "base biped class");
    COLOR(255 0 0);
    think = RespawnBipedDo;
    //dprint("biped spawn function\n");
    nextthink = time + 0.3;
  };
};

INFO(info_monster_spawnpoint, "Targetname, Spawnflags", "monster respawn location");

//monster spawning controller
//decides how many bipeds, of what class and attributes to spawn at spawnpoints
//behavior dependent on wave number
class spawner_controller : entity {
  float squadtype;
  //string target
  //float style

  void() spawner_controller = {
    fgdprint("@fgd \n@PointClass base(Target) = spawner_controller : \"spawner controller\" [");
    FLOAT(style, 0, "squad class style");
  };
};

void() usecmdlist = {
    if (self.commandlist){
    other = self;
    self = self.commandlist;
    self.use();}
  else dprint("no command list\n");
};

float(float f) floatoffield = {
  field_t testfield = entityfieldref(f);
  return(self.testfield);
};

class squad_c : entity {
  //objective_c objective;
  float traitor;
  float strength;
  float population;
  //platoon_c platoon;
  float squadtype; //what is it doing? 0 no squad, 1 no platoon, 2 forward...
  tracked_c tracked;
  //float refzero;
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
    squadtype = 0;
  };
};

class squad_nosquad : squad_c {
  void() squad_nosquad = {
    style = FL_NOSQUAD;
  };
};

typedef struct
{
	squad_c squad0;
} squadlist_t[20];
squadlist_t unassignedlist;

void(squad_c squad) unassigned = {
  int i = 0;
  squad_c test;
  while (i < 20) {
    test = unassignedlist[i].squad0;
    if !(test) {
        unassignedlist[i].squad0 = squad;
        dprint("unassigned list "); dprint(ftos(i + 1)); dprint(" squads\n");
        break;
      }
    i++;
  }
  //else give up
};

class spawnpoint_c : entity {
  float respawns;
  float count;

  virtual void() spawndo = {};

//make biped do respawn biped do
nonvirtual void() RespawnBipedTry = {
  switch (this.spawnflags) {
    case BIPED_DONTRESPAWN : {
      this.think = sub_noop;
      break;
    }
  case BIPED_SPAWNED : {
    if (this.runtime_current < this.runtime_minimum) {
      if (this.count < this.respawns) {
        this.spawndo();
        this.runtime_current += 1;
      }
      //else this.think = sub_noop; do nothing
      break;
    }
    else {
    this.nextthink = time + this.respawntime;
    break;
    }
  }
  default : {
    if !(this.runtime_maximum) {
        this.spawndo();
        //dprint("called spawndo\n");
        this.runtime_current += 1;
        break;
      }
    if (this.runtime_current < this.runtime_maximum) {
      this.spawndo();
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

  nonvirtual void() IsSpawner = {
  this.nextthink = time + 0.3;
  this.think = RespawnBipedTry;
  //this.modelindex = 0;
  //dprint("is spawner\n");
 };

  void() spawnpoint_c = {
    think = RespawnBipedTry;
    nextthink = time + 0.3;
    //setmodel(this, gamemodels "cubeman.mdl");
  };
};

class platoon_c : entity {
 // objective_c objective;
  float traitor;
  float pop;
  squad_c squad0;
  squad_c squad1;
  squad_c squad2;
  squad_c squad3;

  void() platoon_c = {
    //refzero = findentityfield("squad0");
  };
};

biped_class (float f, squad_c squad) memberref = {
  field_t checkfield = entityfieldref (findentityfield (strcat (
                                                                "squad_c::__mmember",
                                                                ftos (f))));
  return (squad.checkfield); }

class wave_c : entity {
  float endcond; //+kill count to end wave
  float spawns; //number of spawns allotted to wave
  float spawndelay; //time between waves/biped respawn time
  //float estate activation state
  float runtime_max; //local runtime max
  float runtime_min; //local runtime min
  string spawncontrollers; //target spawn controllers
  //string target next wave
  //string targetname find this wave
  //float style controller style control
  entity firstcontroller;

  virtual void() think = {
    //check end cond ()
    //check spawns
    //check rt min
    //delay
    //check rt max
    //spawn_request()
    //nextthink = time + 1
  };

    void() wave_c {
      //create controller links - spawn point links on controller spawn
  };
};
class wave_class : wave_c {
  void() wave_class = {
    INFO(wave_class, "Target, Targetname, Spawnflags", "wave controller");
    FLOAT(endcond, 0, "+kill count to end wave");
    FLOAT(spawns, 0, "number of spawns allotted to wave");
    FLOAT(spawndelay, 3, "time between waves/biped respawns");
    FLOAT(runtime_max, 20, "local runtime max spawns");
    FLOAT(runtime_min, 0, "local runtime min spawns");
    STRING(spawncontrollers, target_destination, "Name");

  };
};

float(float remaining) spawner_use;

  void() spawn_request = {
    wave_c wave = self;
    float remaining = wave.spawns;
    entity first = wave.firstcontroller;
    //loop controllers --assume linking set up
    entity test = first;
    while (remaining) {
      if !(test) break;
      self = test;
      remaining = spawner_use(remaining);
      //sv_spawners.qc 1
      test = test.enemy;
      if (test == first) break;
    }
    wave.spawns = remaining;
    self = wave;
  };

class objective_c : entity {
  string firinggroup; //to find zones
  trigger_zone zone1;
  trigger_zone zone2;
  trigger_zone zone3;
  trigger_zone zone4;
  float control; //block action flags
  float style; //force action flags
  float type;
  float popcap; //max pop of all squads
  float pop;
  platoon_c platoon; //list of all squads
  float minstrength; //self-imposed condition
  //cmdlist_c conditions; //targetname
  //float team

  nonvirtual void() objectiveDo = {
    platoon_c plat = this.platoon;
    this.style = ACT_GUARD; //force TODO
    squad_c squad = plat.squad0;
    if !(squad) dprint("objDo with no squad!\n");
    //else dprint("objDo squad found\n");
    if !(squad.member0) dprint("no members in squad!/n");
    //else dprint(squad.member0.classname);
    //dprint(squad.member1.classname); dprint("is member1\n");
    //float ref = squad.refzero;
    //float ref = squadmember0;
    float ref = 0;
    //dprint(ftos(ref)); dprint(entityfieldname(ref));
    float maxref = ref + 8;
    float f = ref;
    biped_class member;
    if !(squad.leader) squad.leader = squad.member0;
    while (f < maxref) {
      member = memberref(f, squad);
      if !(member) break;
      dprint("a member was found\n");
      member.control = this.control;
      member.firinggroup = this.firinggroup;
      member.leader = squad.leader;
      member.action = this.style;
      dprint(ftos(this.style), " action set\n");
      member = FALSE;
      f++;
    } f = ref;
    if !(plat.squad1) return;
    squad = plat.squad1;
    if !(squad.leader) squad.leader = squad.member0;
    while (f < maxref) {
      member = memberref(f, squad);
      if !(member) break;
      member.control = this.control;
      member.firinggroup = this.firinggroup;
      member.leader = squad.leader;
      member.action = this.style;
      member = FALSE;
      f++;
    } f = ref;
    if !(plat.squad2) return;
    squad = plat.squad2;
    if !(squad.leader) squad.leader = squad.member0;
    while (f < maxref) {
      member = memberref(f, squad);
      if !(member) break;
      member.control = this.control;
      member.firinggroup = this.firinggroup;
      member.leader = squad.leader;
      member.action = this.style;
      member = FALSE;
      f++;
    } f = ref;
    if !(plat.squad3) return;
    squad = plat.squad3;
    if !(squad.leader) squad.leader = squad.member0;
    while (f < maxref) {
      member = memberref(f, squad);
      if !(member) break;
      member.control = this.control;
      member.firinggroup = this.firinggroup;
      member.leader = squad.leader;
      member.action = this.style;
      member = FALSE;
      f++;
    }

  };

  nonvirtual float() fillPlatoon = {
  float popnow = this.pop;
  float maxpop = this.popcap;
  float minpop = this.minstrength;
  platoon_c plat = this.platoon;
  //find squad not assigned type
  int i = 0;
  squad_c test;
  if !(plat.squad0){
      while (i < 20) {
        test = unassignedlist[i].squad0;
        if !(test.population > (maxpop - popnow)) {
          if (test.style & FL_NOSQUAD){
            test.style -= FL_NOSQUAD;
          }
          else test.style -= FL_UNASSIGNED;
          test.style += FL_ASSIGNED;
          plat.squad0 = test;
          unassignedlist[i].squad0 = FALSE;
          popnow += test.population;
          dprint("squad added\n");
          if (popnow == maxpop) return (1);
          break;
        }
        i++;
      }
      i = 0;
    }
  if !(plat.squad1){
      while (i < 20) {
        test = unassignedlist[i].squad0;
        if !(test.population > (maxpop - popnow)) {
          if (test.style & FL_NOSQUAD){
            test.style -= FL_NOSQUAD;
          }
          else test.style -= FL_UNASSIGNED;
          test.style += FL_ASSIGNED;
          plat.squad1 = test;
          unassignedlist[i].squad0 = FALSE;
          popnow += test.population;
          dprint("squad added\n");
          if (popnow == maxpop) return (1);
          break;
        }
        i++;
      }
      i = 0;
    }
  if !(plat.squad2){
      while (i < 20) {
        test = unassignedlist[i].squad0;
        if !(test.population > (maxpop - popnow)) {
          if (test.style & FL_NOSQUAD){
            test.style -= FL_NOSQUAD;
          }
          else test.style -= FL_UNASSIGNED;
          test.style += FL_ASSIGNED;
          plat.squad2 = test;
          unassignedlist[i].squad0 = FALSE;
          popnow += test.population;
          dprint("squad added\n");
          if (popnow == maxpop) return (1);
          break;
        } i++;
      } i = 0;
    }
  if !(plat.squad3){
      while (i < 20) {
        test = unassignedlist[i].squad0;
        if !(test.population > (maxpop - popnow)) {
          if (test.style & FL_NOSQUAD){
            test.style -= FL_NOSQUAD;
          }
          else test.style -= FL_UNASSIGNED;
          test.style += FL_ASSIGNED;
          plat.squad3 = test;
          unassignedlist[i].squad0 = FALSE;
          popnow += test.population;
          dprint("squad added\n");
          if (popnow == maxpop) return (1);
          break;
        } i++;
      } i = 0;
    }
return (popnow > minpop);
//if (popnow > minpop) return (1);
  //(from a global tracked_c?) unassigned manager function?
  //if nosquad type reassign biped
  //check max and
  //assign type to squad
  //assign squad to platoon
  //check min and loop
  //if can't find check min
  //if < min return 0 else 1
return(0);
};

  virtual void() use = {
    dprint("objective use\n");
    //make platoon
    platoon_c currentplatoon = this.platoon;
    if !(currentplatoon) this.platoon = currentplatoon = spawn(platoon_c);
    currentplatoon.style = this.style;
    dprint(ftos(this.style), " platoon style set\n");
    //make squads
    //check population
    //assign style to platoon
    if (fillPlatoon()) objectiveDo();
    //assign firing group to platoon
    //else cry about it
    //keep checking platoon state until inactive
  };

  void() objective_c = {
   if !(this.style) this.style = ACT_GUARD; //default objective
   //this.style = 16384;
   dprint(ftos(this.style), "objective style set\n");
  };
};

class objective_class : objective_c {
  void() objective_class = {
    fgdprint("@fgd\n@PointClass base(Spawnflags, Target, Targetname) color(0 0 255) = objective_class : \"objective placed on map"
             "\ncontrol(Flags) actions blocked when assigned to this objective"
             "\nstyle(Flags) action flags forced when assigned to this objective\" \n[");
    STRING(firinggroup, target_dest, "Name");
    FLAGS(control, 0, "[\n"
          "1 : \"ACT_SLEEP\" : 0\n"
          "2 : \"ACT_FIGHT\" : 0\n"
          "4 : \"ACT_FLEE\" : 0\n"
          "8 : \"ACT_UNCOVER\" : 0\n"
          "16 : \"ACT_GUARD\" : 0\n"
          "32 : \"ACT_SEARCH\" : 0\n"
          "64 : \"ACT_WAIT\" : 0\n"
          "128 : \"ACT_VEHICLE\" : 0\n"
          "256 : \"ACT_CHARGE\" : 0\n"
          "512 : \"ACT_OBEY\" : 0\n"
          "1024 : \"ACT_CONVERSE\" : 0\n"
          "2048 : \"ACT_AVOID\" : 0\n"
          "]");
    FLAGS(style, 0,  "[\n"
          "1 : \"ACT_SLEEP\" : 0\n"
          "2 : \"ACT_FIGHT\" : 0\n"
          "4 : \"ACT_FLEE\" : 0\n"
          "8 : \"ACT_UNCOVER\" : 0\n"
          "16 : \"ACT_GUARD\" : 1\n"
          "32 : \"ACT_SEARCH\" : 0\n"
          "64 : \"ACT_WAIT\" : 0\n"
          "128 : \"ACT_VEHICLE\" : 0\n"
          "256 : \"ACT_CHARGE\" : 0\n"
          "512 : \"ACT_OBEY\" : 0\n"
          "1024 : \"ACT_CONVERSE\" : 0\n"
          "2048 : \"ACT_AVOID\" : 0\n"
          "]");
    FLAGS(type, 0, "[\n"
          "2 : \"defend this point\" : 1\n"
          "]");
    FLOAT(popcap, 0, "max bipeds assigned to task if non-zero");
    FLOAT(minstrength, 0, "min bipeds assigned for task to activate");
    FLAGS(team, 0, "[\n"
          "2 : \"team NATO\" : 0\n"
          "4 : \"team NAZI\" : 0\n"
          "8 : \"team HYPE\" : 0\n"
          "16 : \"team LIST\" : 0\n"
          "32 : \"team HELL\" : 0\n"
          "]")
  };
};

//class player_class : entity = {
//  void() player_class = {
//    currentgame.basictraits();
//  };
//};

