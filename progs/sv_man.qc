//BIPED_HUMAN = human npc

$frame basis
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame key9
$frame pain1 pain2 pain3 //pain4
$frame key14
$frame die1 die2
$frame shoot1 shoot2
$frame melee1 melee2
$frame bark1 bark2
$frame reload1 reload2
$frame aggro1 aggro2
$frame evade1 evade2 evade3 evade4 evade5 evade6
$frame grenade1 grenade2 grenade3 grenade4 grenade5 grenade6 grenade7
$frame key39
$frame run1 run2 run3 run4 run5 run6
$frame board1 drive1
$frame crouch1 crouch2


//BPCLASS(biped_man, "human biped");
RTINIT(biped_man);
class biped_man : biped_class {

nonvirtual void() man_stand1 = [$key9, man_stand1] {ai_idle(); //dprint("man stand\n");
};

nonvirtual void() man_walk8 = [$walk8, this.th_walk]{movetogoal(8);};
nonvirtual void() man_walk7 = [$walk7, man_walk8]{movetogoal(8);};
nonvirtual void() man_walk6 = [$walk6, man_walk7]{movetogoal(8);};
nonvirtual void() man_walk5 = [$walk5, man_walk6]{movetogoal(8);};
nonvirtual void() man_walk4 = [$walk4, man_walk5]{ai_walk(8);};
nonvirtual void() man_walk3 = [$walk3, man_walk4]{movetogoal(8);};
nonvirtual void() man_walk2 = [$walk2, man_walk3]{movetogoal(8);};
nonvirtual void() man_walk1 = [$walk1, man_walk2] {
  dprint("man_walk1\n");
  ai_walk(6);
};

void() man_run1 = {

};

void() man_pain3 = [$pain3, man_stand1]{};
void() man_pain2 = [$pain2, man_pain3]{};
void(entity inflictor, float damage) man_pain1 = [$pain1, man_pain2] {
  dprint("man_pain1\n");
  usecmdlist();
};

void() man_die2 = [$die2, man_die2] {spawn_corpse(); remove(this);};
void() man_die1 = [$die1, man_die2]{dprint("man_die1\n");};

void() man_charge1 = {
  ai_charge(8);
  this.frame++;
  if (this.frame < $run1) this.frame = $run1;
  else if (this.frame > $run6) this.frame = $run1;
  this.nextthink = time + 0.1;
};

void() man_shoot1 = {
  this.frame++;
  if (this.frame < $shoot1) this.frame = $shoot1;
  else if (this.frame > $shoot2) this.frame = $shoot1;
  if (this.frame == $shoot1) {
    ai_shoot();
    //this.think = this.th_charge;
  }
  else if (this.frame == $shoot2) this.think = this.th_charge;
  this.nextthink = time + 0.1;
};

void() man_melee1 = {};

void() man_bark1 = {};

void() man_reload1 = {};

void() man_aggro1 = {};

void() man_evade1 = {};

void() man_grenade1 = {};

void() man_board1 = {};
void() man_unboard1 = [$board1, man_stand1]{};

void() man_crouch1 = {};
void() man_shield1 = {};
void() man_jump1 = {};
void() man_drive1 = {};
void() man_turret1 = {};
void() man_uncover1 = {};
void() man_avoid1 = {};
void() man_sleep1 = {};
void() man_alert1 = {};
void() man_flee1 = {};
void() man_converse1 = {};

 nonvirtual void() style_grunt = {
   dprint("style grunt\n");
   setmodel(this, gamemodels "police.mdl"); //for demo
   if (team == TEAM_NAZI) skin = 2;
   else if (team == TEAM_ARMY) skin = 4;
   //weapon - how did I make him spawn with one?
   //respawnbipeddo >> virtualweapon() in sv_weapons.qc
   weapon = WEAPON_BATTLERIFLE;
 };

 nonvirtual void() style_heavy = {
   dprint("style heavy\n");
   setmodel(this, gamemodels "police.mdl");
   if (team == TEAM_NAZI) skin = 2;
   else if (team == TEAM_ARMY) skin = 4;
   weapon = WEAPON_ROCKET;
 };

 void() biped_man = {
  //assign to nosquad
   dprint("biped man\n");
      squad_nosquad squad = spawn(squad_nosquad);
      squad.member0 = this;
      squad.style += this.style;
      //register with unassigned_t
      unassigned(squad);

//choices MAN_GRUNT, MAN_HEAVY, MAN_ELITE
    if !(style) style = MAN_GRUNT;
    //ignoring precache for now
    switch (style) {
    case MAN_GRUNT : style_grunt(); break; //method, not unique function
      //if (team == TEAM_NAZI);//setmodel(this, nohelmet); skin = 2; break;
      //else if (team == TEAM_ARMY); //setmodel(this, helmet); skin = 4; break;
    case MAN_HEAVY : style_heavy(); break;
      }
   BPBODY(biped_man, "human enemy");
   ENTMODEL("cubeman.mdl");
   ENTMODEL("police.mdl");
   setsize(this, '-16 -16 16', '16 16 160');
   health = 80;
   BPTHINK(man);
   team = TEAM_NAZI;
   yaw_speed = 8;
   weapon_use = sub_noop;
   //ANIMATE(man, crouch, 2) + 1; END //dont need a macro to do this.
   //dprint("man spawn function\n");
 };
};
