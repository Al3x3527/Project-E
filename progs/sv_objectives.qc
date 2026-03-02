
  void() spawn_request;
class wave_c : entity {
  //float frags; kills to end wave
  //max_health float endcond; //spawns + rt to end wave
  //health float spawns; //number of spawns allotted to wave
  //respawntime float spawndelay; //time between waves/biped respawn time
  //float estate activation state
  //float runtime_max; //local runtime max
  //float runtime_min; //local runtime min
  //float runtime_now; no local runtime?
  string spawncontrollers; //target spawn controllers (noise)
  //string target next wave
  //string targetname find this wave
  //global monster runtime instead (respawning only)
  //float style controller style control
  entity lastcontroller;
  //float wait time to next use

  nonvirtual void(entity controller) link_spawnpoints = {
    entity start = findtarget(controller.target);
    entity test = FALSE;
    dprint("link spawnpoints\n");
    if !(start) {dprint("err controller no spawnpoints\n"); return;}
    while (test != start) {
      if !(test) test = start;
      test.enemy = findmoretargets(test, controller.target);
      if !(test.enemy) break;
      test = test.enemy;
      dprint("spawnpoint linked\n");
    }
  };

  nonvirtual void() link_controllers = {
    dprint("link controllers\n");
    //float i = 0;
    if !(style) dprint("err link controllers no style\n");
    lastcontroller = findtarget(noise);
    if !(lastcontroller) { dprint(spawncontrollers); dprint(" err no spawn controller\n"); return;}
    else dprint(lastcontroller.classname); dprint(" spawn controller found\n");
    entity test = FALSE;
    while(test != lastcontroller) {
      //i++;
      dprint("link controllers new link\n");
      if !(test) test = lastcontroller;
      test.enemy = findmoretargets(test, spawncontrollers);
      test.style = style;
      if !(test.style) dprint("err no style given\n");
      link_spawnpoints(test);
      if (test.enemy) test = test.enemy;
      else break;
    }
    //dprint(ftos(i)); dprint(" controllers linked\n");
  };

  nonvirtual void() wave_suspend;
  nonvirtual void() wave_resume = {
    dprint("wave resume\n");
    entity test = this;
    while (test.estate != TRUE) {
      test.estate = TRUE;
      test = test.enemy;
      if !(test) {dprint("err expected enemy\n"); return;}
    }
    use = wave_suspend;
  };

  nonvirtual void() wave_suspend = {
    dprint("wave suspend\n");
    estate = FALSE;
    nextthink = time + 1;
    use = wave_resume;
  };

  nonvirtual void() wave_end = {
    dprint("wave end\n");
    if (this.enemy)
      this.enemy.nextthink = time + 0.3;
  };

  nonvirtual void() calc_endcond = {
    max_health = health - frags;
  };

  nonvirtual void() wave_think = {
    if !(estate) return;
    dprint("wave think do\n");
    //check end cond ()
    if (max_health > (health + monsters_runtime.runtime_current)) wave_end(); //keep thinking
    //check spawns ???
    //check rt min
    if !(monsters_runtime.runtime_current > runtime_min) spawn_request();
    //delay
    if (monsters_runtime.runtime_current < runtime_max)
      if (time > wait) {
        spawn_request();
        wait = time + respawntime;
      }
    if (health)
      nextthink = time + 1;
  };

  nonvirtual void() wave_start = {
    dprint("wave start\n");
    setorigin(this, this.origin + '0 0 8');
    if !(style) dprint("wave start no style\n");
    link_controllers();
    calc_endcond();
    estate = TRUE;
    think = wave_think;
    nextthink = time + 1;
  };

    void() wave_c {
      think = wave_start;
      use = wave_suspend;
      spawncontrollers = noise;
      //nextthink = time + 0.3;
      //create controller links - spawn point links on controller spawn
  };
};
class wave_class : wave_c {
  void() wave_class = {
    INFO(wave_class, "Target, Targetname, Spawnflags", "wave controller");
    FLOAT(frags, 0, "+kill count to end wave");
    FLOAT(health, 0, "number of spawns allotted to wave");
    FLOAT(respawntime, 3, "time between waves/biped respawns");
    FLOAT(runtime_max, 20, "local runtime max spawns");
    FLOAT(runtime_min, 0, "local runtime min spawns");
    STRING(noise, target_destination, "spawn controllers");
    FLAGS(style, 8, "[\n"
          "8 : \"MAN_GRUNT\" : 1\n"
          "16 : \"MAN_HEAVY\" : 0\n"
          "]");
  };
};

float(float remaining) spawner_use;

void() spawn_request = {
  dprint("spawn request\n");
  wave_c wave = self;
  //dprint(ftos(self.style)); dprint(" is style\n");
  float remaining = wave.health; //or another number
  entity last = wave.lastcontroller;
  //loop controllers --assume linking set up
  if !(last){
      wave.think = wave.wave_start;
      dprint("err wave not started\n");
      return;
    }
  self = last; //NOTE: self changes here!
  //dprint(self.classname); dprint(" spawner use\n");
  //one controller per think
  remaining = spawner_use(remaining);
  //wave.runtime_now += (wave.spawns - remaining); //update loc rt
  if (last.enemy) {
    //if (last == last.enemy) dprint("err link is self\n");
    dprint(last.classname);
    wave.lastcontroller = last.enemy;
    //dprint("linked controller found\n");
    }
  //else {dprint("no linked controllers\n");}
  //else dprint("err expected controller chain\n");
  wave.health = remaining;
  self = wave;
  //self.nextthink = time + wave.delay; in wave.think
};

class objective_c : entity {
  string firinggroup; //to find zones (noise)
  trigger_zone zone1;
  trigger_zone zone2;
  trigger_zone zone3;
  trigger_zone zone4;
  //float control; //block action flags
  //float style; //force action flags
  float type; //armortype
  //max_health float popcap; //max pop of all squads
  //health float pop;
  platoon_c platoon; //list of all squads
  //frags float minstrength; //self-imposed condition
  //cmdlist_c conditions; //targetname
  //float team
  //target string wavetarget;
  //enemy wave ent

  nonvirtual void() objectiveDo = {
    dprint("objectiveDo\n");
    platoon_c plat = this.platoon;
    this.style = ACT_GUARD; //force TODO
    squad_c squad = plat.squad0;
    if !(squad) { dprint("objDo with no squad!\n"); return; }
    if !(squad.classname) {dprint("objDo err squad no classname\n"); return;}
    if !(squad.member0) { dprint("no members in squad!\n"); return; }
    if !(squad.member1) { dprint("no member1\n");}
    //float ref = 0;
    float maxref = 8;
    float f = 0;
    //TODO: clean up this squad-member stuff
    biped_class member;
    if !(squad.leader) squad.leader = squad.member0;
    while (f < maxref) {
      member = memberref(f, squad);
      if !(member.style) { dprint("no more members\n"); return; }
      dprint(strcat("squad0 ", ftos(f), " a member was found\n"));
      member.control = this.control;
      member.firinggroup = this.firinggroup;
      member.leader = squad.leader;
      member.action = this.style;
      //dprint(ftos(this.style), " action set\n");
      member = FALSE;
      f++;
    } f = 0;
    if !(plat.squad1) return;
    squad = plat.squad1;
    if !(squad.leader) squad.leader = squad.member0;
    while (f < maxref) {
      member = memberref(f, squad);
      if !(member) return;
      member.control = this.control;
      member.firinggroup = this.firinggroup;
      member.leader = squad.leader;
      member.action = this.style;
      member = FALSE;
      f++;
    } f = 0;
    if !(plat.squad2) return;
    squad = plat.squad2;
    if !(squad.leader) squad.leader = squad.member0;
    while (f < maxref) {
      member = memberref(f, squad);
      if !(member) return;
      member.control = this.control;
      member.firinggroup = this.firinggroup;
      member.leader = squad.leader;
      member.action = this.style;
      member = FALSE;
      f++;
    } f = 0;
    if !(plat.squad3) return;
    squad = plat.squad3;
    if !(squad.leader) squad.leader = squad.member0;
    while (f < maxref) {
      member = memberref(f, squad);
      if !(member) return;
      member.control = this.control;
      member.firinggroup = this.firinggroup;
      member.leader = squad.leader;
      member.action = this.style;
      member = FALSE;
      f++;
    }

  };

  nonvirtual float() fillPlatoon = {
    squad_c test;
    //float popnow = health;
    float maxpop = max_health;
    float minpop = frags;
    platoon_c plat = this.platoon;
    squad_c asquad;
    int ref = 0;
    float f = 0;
    biped_class testbiped = FALSE;
    int i = 0;
    //dprint("fill platoon\n");
             //new squad or append?
    while (ref < 4) { //squad slot
      while (i < 20) { //NOTE not the problem loop.
        test = FALSE;
        test = unassignedlist[i].squad0;
        if !(test) { //NOTE more robust check no effect
            //dprint("no unassigned remain\n");
            return(-1); } //worldspawn no unassigned
        if !(test.population > (maxpop - health)) {
            asquad = FALSE;
            if !(plat.classname) {dprint("fillplatoon err no plat classname\n"); return(0);}
            //dprint("calling squadref from fillplatoon\n");
            asquad = squadref(ref, plat);
            if !(asquad) { //new squad
                dprint(strcat(ftos(i), ftos(ref), ftos(f), "\n"));
                dprint(ftos(ref)); dprint(" new squad\n");
                if (test.style & FL_NOSQUAD){
                  test.style -= FL_NOSQUAD;
                } else test.style -= FL_UNASSIGNED;
                test.style += FL_ASSIGNED;
                //test.classname = "assigned squad"; //NOTE was squad nosquad
                test.firinggroup = firinggroup;
                test.nextthink = time + .1;
                if !(squadwrite(ref, plat, test)) { //NOTE SQUADWRITE
                    dprint(strcat("squad", ftos(ref), " ", plat.classname,
                                  test.classname, " write fail\n"));
                    return(0);
                  } //plat.squad0 = test;

                asquad = squadref(ref, plat);
                if !(asquad == test) {dprint("err test not written to field\n");
                  dprint(strcat(asquad.classname, " is asquad ", test.classname, " is test\n"));}
                //else {
                 // dprint(asquad.classname);
                  //dprint(" is asquad, field really was set to test squad\n");
                  //}
                f ++;
              }
            else { //append squad
              while (f < 8) { //platoon squads
                //NOTE: appending squad
                testbiped = FALSE;
                // unnassigned[i], squad[ref], member[f]
                dprint(strcat(ftos(i), ftos(ref), ftos(f), "\n"));
                if !(asquad.classname) {dprint("err asquad no classname aborting memberref\n"); return (0);}
                dprint("memberref expecting nothing\n");
                testbiped = memberref(f, asquad); //plat sq member
                if (testbiped){
                  dprint("nonerr unexpected member\n");
                  //eprint(testbiped);
                  if (testbiped.style) {
                    f++;
                    dprint(strcat("member slot is ", testbiped.classname, "\n"));
                    eprint(testbiped);
                  }
                  else f++;
                }
                else {
                //if !(testbiped.style) {//NOTE: open member slot
                    if !(test.member0) dprint("err no member0\n");
                    //FIXME
                    memberwrite(test.member0, f, asquad); //member to slot.memberf
                    dprint("memberref expecting entity\n");
                    if !(memberref(f, asquad)) {
                        dprint("err write failed\n");
                        //eprint(test.member0);
                        //return 0;
                      }
                    else {dprint("memberwrite confirmed\n");}
                    f++;
                    break; //get new unassigned
                  }
                //}
              }
              if (f > 7) {
                ref ++; //squad full
                f = 0;
              } //both cases
            }
            unassignedlist[i].squad0 = FALSE;
            health += test.population;
            //dprint(ftos(i)); dprint(" index "); dprint("squad added\n");
            if (health == maxpop) {
              dprint(ftos(health)); dprint(" platoon full\n");
              return (1); }
          } else { dprint("no room in platoon\n"); return(0); }
          //all squads used
          //return(0);
          //test.action = this.style; //NOTE: force squad behavior in obj do
        i++;
      }
    }
    dprint("fill platoon we shouldn't be here\n");
    return (health > minpop);

  };

  nonvirtual void() link_firingpoints = {
    //dprint("link firingpoints\n");
    entity point = world;
    int cnt = 0;
    point = findtarget(firinggroup);
    if (point.enemy) return;
    if !(point) { dprint("err no firingpoints link firingpoints\n"); return; }
    while (point != world) {
      cnt++;
      point.enemy = findmoretargets(point, firinggroup);
      point = point.enemy;
    }
    //dprint(strcat(ftos(cnt), "firingpoints linked\n"));
  };

  virtual void() use = {
    //dprint("objective use\n");
    //first start waves
    enemy = findtarget(target);
    if !(enemy) {dprint("err no target wave\n"); return;}
    enemy.nextthink = time + 0.3;
    link_firingpoints(); //TODO don't run every time?
    //make platoon
    platoon_c currentplatoon = this.platoon;
    if !(currentplatoon) { this.platoon = currentplatoon = spawn(platoon_c);
    currentplatoon.style = this.style;
    //dprint(ftos(this.style), " platoon style set\n");
    //if (max_health) currentplatoon.max_health = this.max_health;
    //else currentplatoon.max_health = 80;
    //currentplatoon.frags = this.frags;
    }
    //make squads
    //check population
    //assign style to platoon
    if !(max_health) max_health = 80;
    fillPlatoon(); //TODO fix spam before spawns
    if (this.health) {
      dprint(ftos(health)); dprint(" objective health\n");
      if !(frags > health) objectiveDo();
      else dprint("objective does not meet min pop\n");
        }
    else {
      //dprint("objective no pop\n");
      think = use;
      nextthink = time + 1.4;
    }
    //assign firing group to platoon
    //else cry about it
    //keep checking platoon state until inactive
  };

  void() objective_c = {
   if !(this.style) this.style = ACT_GUARD; //default objective
   type = armortype;
   firinggroup = noise;
   //this.style = 16384;
   //dprint(ftos(this.style), "objective style set\n");
  };
};

class objective_class : objective_c {
  void() objective_class = {
    fgdprint("@fgd\n@PointClass base(Spawnflags, Target, Targetname) color(0 0 255) = objective_class : \"objective placed on map"
             "\ncontrol(Flags) actions blocked when assigned to this objective"
             "\nstyle(Flags) action flags forced when assigned to this objective\" \n[");
    STRING(noise, target_dest, "firinggroup");
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
    FLAGS(armortype, 0, "[\n"
          "2 : \"defend this point\" : 1\n"
          "]");
    FLOAT(max_health, 0, "max bipeds assigned to task if non-zero");
    FLOAT(frags, 0, "min bipeds assigned for task to activate");
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
