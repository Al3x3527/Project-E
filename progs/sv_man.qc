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
$frame run1 run2 run3 run4 run5 run6
$frame board1 drive1
$frame crouch1 crouch2

void() man_stand1 = [$key9, man_stand1] {dprint("man_stand1\n");};

void() man_walk1 = [$walk1, man_walk2] {dprint("man_walk1\n");};
void() man_walk2 = [$walk2, man_walk3]{};
void() man_walk3 = [$walk3, man_walk4]{};
void() man_walk4 = [$walk4, man_walk5]{};
void() man_walk5 = [$walk5, man_walk6]{};
void() man_walk6 = [$walk6, man_walk7]{};
void() man_walk7 = [$walk7, man_walk8]{};
void() man_walk8 = [$walk8, man_walk1]{};

void() man_run1 = [$run1, man_run2] {dprint("man_run1\n");};
void() man_run2 = [$run2, man_run3] {};
void() man_run3 = [$run3, man_run4]{};
void() man_run4 = [$run4, man_run5]{};
void() man_run5 = [$run5, man_run6]{};
void() man_run6 = [$run6, man_run1]{};
//void() man_run7 = [$walk7, man_run8]{};
//void() man_run8 = [$walk8, man_run1]{};

void(entity inflictor, float damage) man_pain1 = [$pain1, man_pain2] {
  dprint("man_pain1\n");
  if (self.commandlist){
    other = self;
    self = self.commandlist;
    self.use();}
  else dprint("no command list\n");
};
void() man_pain2 = [$pain2, man_pain3]{};
void() man_pain3 = [$pain3, man_stand1]{};
//void() man_pain4 = [$pain4, man_stand1]{};

void() man_die1 = [$die1, man_die2]{dprint("man_die1\n");};
void() man_die2 = [$die2, man_die2] {spawn_corpse(); remove(self);};

void() man_charge1 = [$run1, man_charge2] {};
void() man_charge2 = [$run2, man_charge3]{};
void() man_charge3 = [$run3, man_charge4]{};
void() man_charge4 = [$run4, man_charge5]{};
void() man_charge5 = [$run5, man_charge6]{};
void() man_charge6 = [$run6, man_charge1]{};
//void() man_charge7 = [$walk7, man_charge8]{};
//void() man_charge8 = [$walk8, man_charge1]{};

void() man_shoot1 = [$shoot1, man_shoot2]{};
void() man_shoot2 = [$shoot2, man_stand1]{};

void() man_melee1 = [$melee1, man_melee2]{};
void() man_melee2 = [$melee2, man_stand1]{};

void() man_bark1 = [$bark1, man_bark2]{};
void() man_bark2 = [$bark2, man_stand1]{};

void() man_reload1 = [$reload1, man_reload2]{};
void() man_reload2 = [$reload2, man_stand1]{};

void() man_aggro1 = [$aggro1, man_aggro2]{};
void() man_aggro2 = [$aggro2, man_stand1]{};

void() man_evade1 = [$evade1, man_evade2]{};
void() man_evade2 = [$evade2, man_evade3]{};
void() man_evade3 = [$evade3, man_evade4]{};
void() man_evade4 = [$evade4, man_evade5]{};
void() man_evade5 = [$evade5, man_evade6]{};
void() man_evade6 = [$evade6, man_stand1]{};

void() man_grenade1 = [$grenade1, man_grenade2]{};
void() man_grenade2 = [$grenade2, man_grenade3]{};
void() man_grenade3 = [$grenade3, man_grenade4]{};
void() man_grenade4 = [$grenade4, man_grenade5]{};
void() man_grenade5 = [$grenade5, man_grenade6]{};
void() man_grenade6 = [$grenade6, man_grenade7]{};
void() man_grenade7 = [$grenade7, man_stand1]{};
//ANIMATE(man, grenade, 7) = {man_grenade() = while(frame><)++
#define ANIMATE(nick, key, max) void() nick ## _ ## key = {\
if (this.frame < $ ## key ## 1) this.frame = $ ## key ## 1;\
 else this.frame ++;                                      \
 this.nextthink = time + 0.1;\
if (this.frame == $ ## key ## max) this.frame = $ ## key ## 1\
//if (this.frame == i) {};
#define END };
void() man_board1 = {};
void() man_unboard1 = {};
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

BPCLASS(biped_man, "human biped");
ENTMODEL("cubeman.mdl");
setsize(this, '-16 -16 0', '16 16 80');
health = 80;
BPTHINK(man);
ANIMATE(man, crouch, 2); END
th_crouch = man_crouch;
//dprint("man spawn function\n");
ENDCLASS;
