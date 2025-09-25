//BIPED_HUMAN = human npc

void() man_stand1 = {dprint("man_stand1\n");};
void() man_walk1 = {dprint("man_walk1\n");};
void() man_run1 = {dprint("man_run1\n");};
void(entity inflictor, float damage) man_pain1 = {dprint("man_pain1\n");};
void() man_die1 = {dprint("man_die1\n");};
void() man_charge1 = {};
void() man_shoot1 = {};
void() man_melee1 = {};
void() man_bark1 = {};
void() man_reload1 = {};
void() man_aggro1 = {};
void() man_evade1 = {};
void() man_grenade1 = {};
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
setsize(this, '-16 -16 -40', '16 16 40');
health = 80;
BPTHINK(man);
//dprint("man spawn function\n");
ENDCLASS;
