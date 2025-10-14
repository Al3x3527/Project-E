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
  nonvirtual void() point_touch = {
    dprint("point touch\n");
    if (other.goalentity != this) return;
    other.goalentity = world;
  };
  void() firingpoint_c = {
    touch = point_touch;
    solid = SOLID_TRIGGER;
    setsize(this, '-8 -8 0', '8 8 16');
  };
};

class trigger_zone : entity {
  firingpoint_c point0;
  firingpoint_c point1;
  firingpoint_c point2;
  firingpoint_c point3;
  firingpoint_c point4;
  firingpoint_c point5;
  firingpoint_c point6;
  firingpoint_c point7;
  //firingpoint_c point8;
  //firingpoint_c point9;
  //firingpoint_c point10;
  //firingpoint_c point11;
  //firingpoint_c point12;
  //firingpoint_c point13;
  //firingpoint_c point14;
  //firingpoint_c point15;
  void() trigger_zone = {
    setmodel(this, this.model);
    modelindex = 0;
  };
};

entity (string name) findtarget = {
  name = "test_points"; //force
  return(find(world, targetname, name));};

int (entity e) CheckDist = {
  vector vec = e.origin - self.origin;
  float len = vlen(vec);
  if (len < 16) return(DIST_KREIG);
  if (len < 64) return(DIST_NEAR);
  if (len < 256) return(DIST_MED);
  return(DIST_FAR);
};

class searchpoint_c : entity {
  //style SEARCH_X
  //weapon
  //team
  //origin
  //enemy lookingfor
  virtual void() think = {
    if (this.style == SEARCH_SCRIPTED) return;
    this.enemy = world;
    remove(this);
  };
  virtual void() touch = {
    if (other.goalentity != this) return;
    this.enemy = world;
    other.think = other.th_fooled;
    other.goalentity = world;
    remove(this);
  };
  void() searchpoint_c = {
    nextthink = time + 15;
    classname = "searchpoint";
  };
};

float (entity ent) CheckAlive = {dprint("check alive\n"); if (ent) return(1); return(0);};

float (entity ent) CheckLine = {dprint("check line\n");
  traceline(self.origin, ent.origin, MOVE_NOMONSTERS, self);
  if (trace_fraction == 1) {
    //if (self.status < STA_SIGHT) self.status = STA_SIGHT;
    return(1);
  }
  //if (self.status > STA_UNCERTAIN) self.status = STA_UNCERTAIN;
  return(0);
};// NOTE: not oo function

float (entity ent) addenemy = { //FIXME biped class
  //TODO
  //if (ent.classname == "searchpoint") {
  //  if (self.status < STA_CERTAIN) self.status = STA_CERTAIN;
  //}
  self.enemy = ent;
  dprint("enemy found\n");
  return (1);
};

float (entity ent) addprop = { //FIXME biped class
  //TODO
  return (0);
};

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

class biped_class : entity { //biped spawn point definition
  enemylist_c enemies;
  tracked_c tracked;
  //squad_c squad;
  int traitor;
  entity leader;
  int control;
  int action;
  int status;
  //objective_c objective;
  //string targetcmdlist;
  //cmdlist_c commandlist;
  firingpoint_c firingpoint;
  string firinggroup;

  nonvirtual void() find_status = { //might not use
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
    if (ent.classname == "searchpoint") { //else real
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
      if (CheckLine(ent)) { //else ignore
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
  if (this.enemy.classname != "searchpoint") //FIXME: flags instead?
    if (CheckLine(this.enemy)) this.status = STA_SIGHT;
    else this.status = STA_UNCERTAIN;
  //TODO: searchpoint at enemy.lastseen
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
    FGDbase(Spawnflags Targetname);
    COLOR();
    think = RespawnBipedDo;
    //dprint("biped spawn function\n");
    nextthink = time + 0.3;
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

//class player_class : entity = {
//  void() player_class = {
//    currentgame.basictraits();
//  };
//};

