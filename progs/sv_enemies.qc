float BIPED_DONTRESPAWN = INHIBIT_RESPAWN;
float BIPED_SPAWNED = SPAWNED_ACTIVE;

void() remove_self = {
  remove(self);
}

void() spawn_corpse = {
  entity corpse = spawn();
  setmodel(corpse, self.model);
  setorigin(corpse, self.origin);
  corpse.angles = self.angles;
  corpse.frame = self.frame;
  corpse.angles = self.angles + '90 90 90';
  corpse.think = remove_self;
  corpse.nextthink = time + 10;
};

void() kill_object = {
  dprint("kill object\n");
  spawn_corpse();
  self.movechain = world;
  drop_items();
  remove(self);
}

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
  //float refzero;
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
    //refzero = findentityfield("prop0");
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
 //  float ref = tracked.refzero;
   //float zero = ref;
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
  //dprint("check alive\n");
  if (ent.flags & FL_CLIENT) dprint("check alive client\n");
  if (ent.flags & FL_COVER) return (0);
  if !(ent.health > 0) return(0);
  if (ent) return(1);
  return(0);
};

float (entity ent) CheckLine = {
  //dprint("check line\n");
  traceline(self.origin + self.view_ofs, ent.origin + ent.view_ofs, MOVE_MISSILE, self);
  if (trace_fraction == 1) {
    //if (self.status < STA_SIGHT) self.status = STA_SIGHT;
    return(1);
  }
  else if (trace_ent == ent)
    return(1);
  //if (self.status > STA_UNCERTAIN) self.status = STA_UNCERTAIN;
  return(0);
};// NOTE: not oo function

entity (float dist) RequestSearch = {
  //dprint("search requested\n");
if (self == searchent) {
  if (time < searchtime + 0.25) return (FALSE);
 }
 else if (CheckDist(searchent) < DIST_FAR)
   if (time < searchtime + 0.5) return (FALSE);
dprint("request granted\n");
searchent = self;
searchtime = time;
return(findradius(self.origin, dist, searchchain));
//check all ent.searchchain
}

void() VirtualWeapon;

float (int i, tracked_c test, entity ent) testpropref = {
  entity content;
  if !(test) { dprint("err testpropref bad test tracked_c\n"); return 0;}
 field_t checkfield = entityfieldref( findentityfield (strcat (
                                                               "tracked_c::__mprop",
                                                               itos (i))));
 content = test.checkfield;
 if !(content) test.checkfield = ent;

 return(ent == test.checkfield);
};

float(int i, tracked_c shift) shiftpropfields = {
  field_t oldfield = entityfieldref( findentityfield (strcat (
                                                              "tracked_c::__mprop",
                                                              itos (i+1))));
  field_t newfield = entityfieldref( findentityfield (strcat (
                                                              "tracked_c::__mprop",
                                                              itos (i))));
  shift.newfield = shift.oldfield;
  if (shift.newfield) return 1;
  dprint(strcat("err shift prop fields hit invalid entity at index ", itos(i), "\n"));
  return 0;
};

entity (int i, tracked_c test) getprop = {
  field_t checkfield = entityfieldref( findentityfield (strcat (
                                                              "tracked_c::__mprop",
                                                              itos (i))) );
entity p = test.checkfield;
if !(p) return(FALSE);
return(p);
}
float (entity p) testnavcorners = {
  dprint("test nav corners");
vector vec1;
vector vec2;
//if !(p) return (-1); //no prop
if !(p.flags & FL_CORNER) return(0);
if (p == self.goalentity) return(0);
vec1 = self.goalentity.origin - self.origin;
vec2 = p.origin - self.origin;
if ((vec2 * vec1) > 0) return(1);
return(0);
};

entity(int i, tracked_c test) testpropcover = {
  dprint("test prop cover\n");
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
  //dprint("add prop\n");
  int i = 0;
  if !(this.tracked) {
      dprint("err addprop invalid this.tracked\n");
      return 0;
    }
  //check for open field
  while (i < 20) {
    if (testpropref(i, this.tracked, ent)) return(1);
    i++;
  }
  //shift prop fields
  i = 0;
  while (i < 19) {
    if !(shiftpropfields(i, this.tracked)) break;
    i++;
  }
  this.tracked.prop19 = ent;
  return (1);
};

nonvirtual float (entity ent) addenemy = {
  entity least = ent;
  if !(this.enemies) this.enemies = spawn(enemylist_c);
  if !(ent.scary) dprint("err addenemy no scary\n");

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

  if (least == ent) {
    addprop(ent);
    dprint("add enemy was least\n");
    return(0);
  }
  }
  if !(this.enemy) this.enemy = ent;
  if (this.enemies.foe0 == least) this.enemies.foe0 = ent;
  else if (this.enemies.foe1 == least) this.enemies.foe1 = ent;
  else if (this.enemies.foe2 == least) this.enemies.foe2 = ent;
  else if (this.enemies.foe3 == least) this.enemies.foe3 = ent;
  else dprint("problem in addenemy!\n");
  dprint(strcat(enemy.classname, " is enemy found\n"));
  return (1);
};

nonvirtual float () findfear = {
  dprint("find fear\n");
  entity ent = this.enemy;
  if !(scary) dprint("err findfear no scary\n");
  vector sdanger = this.scary * '1 0 0' + this.movechain.scary * '0 1 0';
  vector odanger = ent.scary * '1 0 0' + ent.movechain.scary * '0 1 0';
  float fear = vlen(odanger - sdanger);

  return(fear > 0);
};

 nonvirtual float () findcover = {
   dprint("find cover\n");
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
dprint("find action\n");
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
  float dist = 700;
  //dprint("find stuff\n");
  ent = RequestSearch(dist);
  if (ent == FALSE) {
    //dprint("Request Declined\n");
    return;
    }
  //dprint("find stuff\n");
  if !(ent) return;
  while (ent) {
    //dprint(strcat(ent.classname, " is ent findstuff\n"));
    if (ent.flags & FL_CLIENT) dprint("client searched\n");
    if (ent.flags | FL_CORNER) {
    if (ent.flags & FL_SEARCHPOINT) { //else real
      if (ent.flags & FL_CLIENT) dprint("client searchpoint found\n");
      if !(CheckLine(ent.enemy)) { //visible ignore
          if (CheckAlive(ent)) {//prop ignore
            if (ent.team != this.team) { //ignore
              dprint("add virtual enemy\n");
              addenemy(ent);
              if (this.status < STA_CERTAIN) this.status = STA_CERTAIN;
              } //team ignore
            } //prop ignore
        }
    } else{ //real
      //dprint("real found\n");
      if (ent.flags & FL_CLIENT) dprint("client found\n");
      if (CheckLine(ent)) { //else check path
        if (ent.solid & SOLID_SLIDEBOX){ //see prop
          if (CheckAlive(ent) && (ent.team != this.team)){  //ignore
              dprint("potential enemy found\n");
              entyaw = vectoyaw (ent.origin - this.origin);
              deltayaw = fabs(thisyaw - entyaw);
              if (deltayaw > 180) deltayaw -= 180;
              if (deltayaw < maxyaw) { //ignore
                dprint(strcat(ent.classname, " add enemy\n"));
                addenemy(ent);
                if (this.status < STA_SIGHT) this.status = STA_SIGHT;
              }
            }
        } else {
          dprint("add prop\n");
          addprop(ent);
        }
      } else { //always see path entities
        if (ent.flags & FL_COVER) {
          dprint("add cover prop\n");
          addprop(ent);
        }
      }
    }
    }
    if (ent.searchchain)
      ent = ent.searchchain;
    else ent = FALSE;
  }
};

nonvirtual void() findgoal = {
  dprint("findgoal\n");
  if (this.goalentity) { dprint("biped has goal\n"); return;}
  if !(this.firinggroup) dprint("no firinggroup\n");
  this.goalentity = findtarget(this.firinggroup);
  if (this.goalentity) {
    this.firingpoint = this.goalentity;
    dprint("firing point found\n");
    }
  else {
    dprint(firinggroup); dprint(" no firing point\n");
    this.goalentity = findtarget(this.target);
    if !(this.target) dprint("no target\n");
    //else dprint(this.target);
  }
  if (this.goalentity){
    this.action = ACT_GUARD;
    this.status = STA_ACTIVE;
    this.think = th_walk;
    dprint("found goal\n");
  }
  else dprint("no goal found\n");
};

nonvirtual void() find_corners = {
  int i = 0;
  entity p = FALSE;
  //tracked_c test = tracked;
  while (i < 20) {
    p = FALSE;
    p = getprop(i, tracked);
    if (p) {
      if(testnavcorners(p))
        goalentity = p;
    }
    else return;
    i++;
  }
};

nonvirtual void() ai_idle = {
 // dprint("ai_idle\n");
  if !(this.action) { //dprint("braindead idle\n");
    return; } //actually return
  if (this.status & STA_IDLE) {
    findstuff();
    if (this.enemy) this.think = this.th_charge;
    dprint("charge from idle\n");
    return;
  } //look for enemies
  if (this.status > 7) {
    if(this.enemy) {
      this.think = this.th_charge;
      dprint("charge from idle 1\n");
      return;
    }
  }
  //if !(this.firingpoint) findgoal(); let squad assign goal
   // else {
    //dprint("idle biped has firingpoint\n");
    //}
  //dprint("ai idle looking for goal\n");
  if !(this.goalentity) this.goalentity = this.firingpoint;
  if (flags & FL_CORNER) flags -= FL_CORNER;
  //think = th_walk;
};

nonvirtual void(float dist) ai_walk = {
  vector goal = goalentity.origin;
  goal.z = 0;
  vector falseorg = origin;
  falseorg.z = 0;
  findstuff();
  if (this.enemy) {this.think = this.th_charge;
    dprint("ai walk charge\n");
    }
  if !(this.goalentity) {
      if !(this.firingpoint)
        think = this.th_guard;
      else {
        goalentity = firingpoint;
      }
  }
  else// dprint("bp has a goal\n");
  //find corners between this and goal
  this.ideal_yaw = vectoyaw(this.goalentity.origin - this.origin);
  sub_changeyaw();
  if !(movetogoal(dist)) {
      //dprint("movetogoal failed in ai_walk\n");
      //if (oldorigin == origin) {
       // if (wait < time) {//just jams a door longer
          //if ( vlen(goal-falseorg) < 16) {
       //  goalentity = firingpoint = world;
    //        dprint("bp has reached corner\n");
            //}
          //wait = time + 0.1;
          //oldorigin = '0 0 0';
        //}
      //findgoal();
      //oldorigin = origin;
     // }
    }
  //else wait = time + 0.1;
};

nonvirtual void(float dist) ai_charge = {
  dprint("ai charge\n");
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
      dprint("ai charge attack\n");
      this.think = this.th_shoot;
};

nonvirtual void() ai_shoot = {
  v_angle = angles;
  this.weapon_use();
};

nonvirtual void() RespawnBipedDo = { //walkmonster start, do
  dprint("respawn biped do\n");
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
  //else {dprint(this.targetcmdlist);dprint("no command list\n");}
  this.enemies = spawn(enemylist_c);
  this.tracked = spawn(tracked_c);

  if(this.weapon){ VirtualWeapon();
    dprint("virtual weapon should spawn\n");
    if !(this.primary) dprint("err no primary weapon\n");
    }
  else { dprint("respawnbipeddo not assigning a weapon\n");}
  //if !(this.squad) this.squad = spawn(squad_c);
  //this.squad.style = this.style + FL_NOSQUAD; in spawn function
};

nonvirtual void() RespawnBipedTry = {
  dprint("respawnbipedtry\n");
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
    scary = 1; //idk
    think = RespawnBipedDo;
    dprint("biped spawn function\n");
    nextthink = time + 0.1;
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
    classname = "spawn controller";
    fgdprint("@fgd \n@PointClass base(Target, Targetname) = spawner_controller : \"spawner controller\" [");
    FLOAT(style, 0, "squad class style");
  };
};

void() usecmdlist = {
    if (self.commandlist){
    other = self;
    self = self.commandlist;
    self.use();}
 // else dprint("no command list\n");
};

float(float f) floatoffield = {
  field_t testfield = entityfieldref(f);
  return(self.testfield);
};

void() squad_guard_think;

class squad_c : entity {
  //objective_c objective;
  float traitor;
  float strength;
  float population;
  string firinggroup;
  //platoon_c platoon;
  float squadtype; //what is it doing? 0 no squad, 1 no platoon, 2 forward...
  //float action; //from obj to biped
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
    think = squad_guard_think;
  };
};

class squad_nosquad : squad_c {
  void() squad_nosquad = {
    style = FL_NOSQUAD;
    population = 1;
    classname = "squad nosquad";
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
    classname = "platoon class";
    //refzero = findentityfield("squad0");
  };
};

biped_class (float f, squad_c squad) memberref = {
  if !(squad) {dprint("member ref err no squad\n"); return (FALSE);}
  field_t checkfield = entityfieldref (findentityfield (strcat (
                                                                "squad_c::__mmember",
                                                                ftos (f))));
  biped_class member = squad.checkfield;
  //dprint((strcat("member ref squad classname ", squad.classname, " field squad_c::__mmember", ftos(f), " member classname ", member.classname)));
  if !(squad) { dprint("memberref err no squad\n"); return(FALSE);}
  if (squad.checkfield) { dprint(" member referenced\n"); return(squad.checkfield); }
  else dprint(" member ref world\n");
  return (FALSE); }

squad_c (float f, platoon_c plat) squadref = {
  if !(plat) {dprint("squadref err no plat"); return(FALSE);}
  field_t checkfield = entityfieldref (findentityfield (strcat (
                                                                "platoon_c::__msquad",
                                                                ftos (f))));
  squad_c test = FALSE;
  if (plat.checkfield)
    test = plat.checkfield;
  if !(test.classname) {dprint(strcat("platoon squad", ftos(f),
                                      " squadref err found squad no classname\n")); return(FALSE);}
  if (test) {}//dprint(strcat("squadref plat classname ", plat.classname,
    //                       ", squad classname ", test.classname,
      //                     ", field platoon_c::__msquad", ftos(f), " squad found\n"));}
  else {dprint("squadref no squad found\n"); return (FALSE);}
  return(test); }

float(float f, platoon_c plat, squad_c squad) squadwrite = {
  if !(plat.classname) {dprint("squadwrite err plat no classname\n"); return(0);}
  if !(squad.classname) {dprint("squadwrite err squad no classname\n"); return(0);}
   field_t checkfield = entityfieldref (findentityfield (strcat (
                                                                "platoon_c::__msquad",
                                                                ftos (f))));
   plat.checkfield = squad;
   squad = FALSE;
   squad = plat.checkfield;
   if !(squad) {dprint("err squadwrite failed\n"); return(0);}
   //if !(squad.classname) {dprint("we somehow lost the classname in squadwrite\n");}
   //dprint(strcat("squad write platoon classname ", plat.classname,
     //            ", field platoon_c::__msquad", ftos(f),
      //           ", squad classname ", squad.classname));
   if (plat.checkfield) { dprint("squad written\n"); return(1);}
   dprint("squad write fail\n"); return(0);
};

void(biped_class member, float f, squad_c squad) memberwrite = {
  field_t checkfield = entityfieldref (findentityfield (strcat (
                                                                "squad_c::__mmember",
                                                                ftos (f))));
  squad.checkfield = member;
  //dprint(strcat("member write squad classname ",squad.classname, "member classname ", member.classname, "field squadd_c::__mmember", ftos(f)));
  if (squad.checkfield) dprint(" member written\n");
  else dprint("member write failed\n");
}
  void() squad_guard_think = {
  squad_c asquad = self;
  int i = 0;
  biped_class testmember;
  entity point;
  entity priority = self.enemy;
  dprint("squad think !!!!!!\n");
  if !(asquad.firinggroup) { dprint("squad think no firinggroup\n"); }
  point = findtarget(asquad.firinggroup);
  while (i < 8) {
    testmember = memberref(i, asquad);
    if !(testmember) break;
    if !(testmember.style) break;
    if (testmember.firingpoint) {
      if (testmember.enemy.scary > priority.scary) {
        dprint("squad guard enemy sharing\n");
        asquad.enemy = priority = testmember.enemy;
        }
      else if (priority) testmember.enemy = priority;
    } else {
      if !(point) { dprint("err no point squad think\n"); break; }
      testmember.firingpoint = testmember.goalentity = point;
      testmember.think = testmember.th_walk;
      point = point.enemy;
      //dprint("firing point set by squad\n");
    }
    i++;
  }
  asquad.think = squad_guard_think;
  asquad.nextthink = time + 1;
};
