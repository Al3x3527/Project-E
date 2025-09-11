//weapon classes using class inheritance
//#define w_placeholder gamemodels"w_placeholder.mdl"
//#define v_placeholder gamemodels"v_placeholder.mdl"
#define w_assault gamemodels"w_AD70.mdl"
#define v_assault gamemodels"v_AD70.mdl"
//#define w_plasrifle gamemodels"w_plasmarifle.mdl"
//#define v_plasrifle gamemodels"v_plasmarifle.mdl"
const float WEAPON_BATTLERIFLE = 2;

void(entity new) switch_weapon = {
 //expect other = player, self = new.enemy
 other.weapon = new.weapon;
 other.weaponmodel = new.weaponmodel;
 other.currentammo = new.currentammo;
 other.weapon_use = new.weapon_use;
 sprint(other, 1, "you switched to the ");
 sprint(other, 1, new.classname);
 sprint(other, 1, "!\n");
}

class weapon_class : entity {
float rateoffire;
float attackvelocity;
float attacktimes;
//void *attackdo(float times); I give up.

virtual float (float times) hitscan = {
  float rof = this.rateoffire;
  float speed = this.attackvelocity;
  dprint("hitscan()!\n");
  return TRUE;
};

virtual void() use_weapon = {
  if (!currentammo) return;
    float times = attacktimes;
    if (currentammo == BOTTOMLESS_CLIP) times = 0; //not congruous
    if (currentammo != UNLIMITED_AMMO) currentammo -= times;
    this.attack(times);
    if (!currentammo) CONSUMEITEM
};
void() weapon_class = {
FGDbase(Spawnflags Targetname) //only affects FGD.
COLOR(206 18 18)
//if (SUB_Inhibit()) return;
 think = IsConsumable;
nextthink = time + 0.3;
weapon_use = use_weapon;
setsize (this, '-16 -24 0', '16 24 16');
//MODELdefault(w_placeholder)
//precache_model(v_placeholder);
//if (!this.weaponmodel) this.weaponmodel = v_placeholder;
};
};

#define WEAPONEQUIP(aclass) {\
 aclass new = spawn(aclass);\
  new.spawnflags = self.spawnflags;\
  new.currentammo = self.currentammo;\
  new.enemy = self;\
  new.solid = SOLID_NOT;\
  if !(other.primary) other.primary = new;\
  else if !(other.secondary) other.secondary = new;\
  else if (other.weapon == other.primary.weapon) other.primary = new;\
  else other.secondary = new;\
  switch_weapon(new);\
}

void() battlerifle_equip;
runtime_t weapon_battlerifle_runtime;
//CLASSDEF(weapon, weapon_battlerifle, "assault rifle placed on map.")
class weapon_battlerifle : weapon_class {
void () weapon_battlerifle = {
  classname = "weapon_battlerifle";
 WEAPONMODELS(w_assault, v_assault)
FLOAT(currentammo, 150, "starting ammo")
weapon = WEAPON_BATTLERIFLE;
rateoffire = 8;
attackvelocity = 120;
attacktimes = 1;
float(float times) attack = { return(hitscan(times)); };
equip = battlerifle_equip;
RUNTIME(weapon_battlerifle_runtime)
//default respawn time
dprint("weapon_battlerifle spawn function\n");
};
};
void() battlerifle_equip = WEAPONEQUIP(weapon_battlerifle);

#define w_plas gamemodels "plasma_rifle.mdl"
#define v_plas gamemodels "v_plasma_rifle.mdl"
void() plasmarifle_equip;
runtime_t weapon_plasmarifle_runtime;
CLASSDEF(weapon_class, weapon_plasmarifle, "plasma rifle")
WEAPONMODELS(w_plas, v_plas)
FLOAT(currentammo, 140, "starting ammo")
rateoffire = 8;
attackvelocity = 80;
attacktimes = 3;
float(float times) attack = { return(hitscan(times)); };
equip = plasmarifle_equip;
RUNTIME(weapon_plasmarifle_runtime)
ENDCLASS
void() plasmarifle_equip = WEAPONEQUIP(weapon_plasmarifle);

#define w_browning gamemodels "browning.mdl"
#define v_browning gamemodels "browning.mdl"
void() browning_equip;
runtime_t weapon_browning_runtime;
CLASSDEF(weapon_class, weapon_browning, "machine gun")
WEAPONMODELS(w_browning, v_browning)
FLOAT(currentammo, 400, "starting ammo")
rateoffire = 8;
attackvelocity = 120;
attacktimes = 1;
float(float times) attack = {return(hitscan(times)); };
equip = browning_equip;
RUNTIME(weapon_browning_runtime)
ENDCLASS
void() browning_equip = WEAPONEQUIP(weapon_browning);

#define w_cannon gamemodels "qp_cannon.mdl"
#define v_cannon gamemodels "qp_cannon.mdl"
void() cannon_equip;
runtime_t weapon_cannon_runtime;
CLASSDEF(weapon_class, weapon_cannon, "cannon")
WEAPONMODELS(w_cannon, v_cannon)
FLOAT(currentammo, 10, "starting ammo")
rateoffire = 1;
attackvelocity = 60;
attacktimes = 1;
float(float times) attack = {return(hitscan(times)); };
equip = cannon_equip;
RUNTIME(weapon_cannon_runtime)
ENDCLASS
void() cannon_equip = WEAPONEQUIP(weapon_cannon);

#define w_sniper gamemodels "qp_m40a5.mdl"
#define v_sniper gamemodels "qp_m40a5.mdl"
void() sniper_equip;
runtime_t weapon_sniper_runtime;
CLASSDEF(weapon_class, weapon_sniper, "sniper")
WEAPONMODELS(w_sniper, v_sniper)
FLOAT(currentammo, 40, "starting ammo")
rateoffire = 4;
attackvelocity = 120;
attacktimes = 1;
float(float times) attack = {return(hitscan(times)); };
equip = sniper_equip;
RUNTIME(weapon_sniper_runtime)
ENDCLASS
void() sniper_equip = WEAPONEQUIP(weapon_sniper);

#define w_rocket gamemodels "qp_rocket_launcher.mdl"
#define v_rocket gamemodels "qp_rocket_launcher.mdl"
void() rocket_equip;
runtime_t weapon_rocket_runtime;
CLASSDEF(weapon_class, weapon_rocket, "rocket launcher")
WEAPONMODELS(w_rocket, v_rocket)
FLOAT(currentammo, 10, "starting ammo")
rateoffire = 1;
attackvelocity = 60;
attacktimes = 1;
float(float times) attack = {return(hitscan(times)); };
equip = rocket_equip;
RUNTIME(weapon_rocket_runtime)
ENDCLASS
void() rocket_equip = WEAPONEQUIP(weapon_rocket);

#define w_smg gamemodels "qp_sentinelsmg.mdl"
#define v_smg gamemodels "qp_sentinelsmg.mdl"
void() smg_equip;
runtime_t weapon_smg_runtime;
CLASSDEF(weapon_class, weapon_smg, "sentinel smg")
WEAPONMODELS(w_smg, v_smg)
FLOAT(currentammo, 140, "starting ammo")
rateoffire = 8;
attackvelocity = 120;
attacktimes = 1;
float (float times) attack = {return(hitscan(times)); };
equip = smg_equip;
RUNTIME(weapon_smg_runtime)
ENDCLASS
void() smg_equip = WEAPONEQUIP(weapon_smg);

#define w_spear gamemodels "qp_spear.mdl"
#define v_spear gamemodels "qp_spear.mdl"
void() spear_equip;
runtime_t weapon_spear_runtime;
CLASSDEF(weapon_class, weapon_spear, "sentinel spear")
WEAPONMODELS(w_spear, v_spear)
FLOAT(currentammo, 40, "starting ammo")
rateoffire = 1;
attackvelocity = 100;
attacktimes = 1;
float (float times) attack = {return(hitscan(times));};
equip = spear_equip;
RUNTIME(weapon_spear_runtime)
ENDCLASS
void() spear_equip = WEAPONEQUIP(weapon_spear);
