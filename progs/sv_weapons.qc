//weapon classes using class inheritance
//#define w_placeholder gamemodels"w_placeholder.mdl"
//#define v_placeholder gamemodels"v_placeholder.mdl"
#define w_assault gamemodels"w_AD70.mdl"
#define v_assault gamemodels"v_AD70.mdl"
//#define w_plasrifle gamemodels"w_plasmarifle.mdl"
//#define v_plasrifle gamemodels"v_plasmarifle.mdl"

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
virtual void() weapon_use = //not weapon.use();
  {
    if (!currentammo) return;
    float times = attacktimes;
    if (currentammo == BOTTOMLESS_CLIP) times = 0;
    if (currentammo != UNLIMITED_AMMO) currentammo -= times;
    this.attack(times);
  };
void() weapon_class = {
FGDbase(Spawnflags | Targetname) //only affects FGD.
COLOR(206 18 18); //bbox color. does nothing in game (unless?)
FGDfield(currentammo, "starting ammo")
//if (SUB_Inhibit()) return;
 think = IsConsumable;
nextthink = time + 0.3;
setsize (this, '-16 -24 0', '16 24 16');
//MODELdefault(w_placeholder)
//precache_model(v_placeholder);
//if (!this.weaponmodel) this.weaponmodel = v_placeholder;
};
};

//CLASSDEF(weapon, weapon_battlerifle, "assault rifle placed on map.")
class weapon_battlerifle : weapon_class {
void () weapon_battlerifle = {
  classname = "weapon_battlerifle";
 WEAPONMODELS(w_assault, v_assault)
FLOAT(currentammo, 150)
rateoffire = 8;
attackvelocity = 120;
attacktimes = 1;
float(float times) attack = { return(hitscan(times)); };

//default respawn time
dprint("weapon_battlerifle spawn function\n");
};
};

#define w_plas gamemodels "plasma_rifle.mdl"
#define v_plas gamemodels "v_plasma_rifle.mdl"
CLASSDEF(weapon_class, weapon_plasmarifle, "plasma rifle")
WEAPONMODELS(w_plas, v_plas)
FLOAT(currentammo, 140)
rateoffire = 8;
attackvelocity = 80;
attacktimes = 3;
float(float times) attack = { return(hitscan(times)); };
ENDCLASS

#define w_browning gamemodels "browning.mdl"
#define v_browning gamemodels "browning.mdl"
CLASSDEF(weapon_class, weapon_browning, "machine gun")
WEAPONMODELS(w_browning, v_browning)
FLOAT(currentammo, 400)
rateoffire = 8;
attackvelocity = 120;
attacktimes = 1;
float(float times) attack = {return(hitscan(times)); };
ENDCLASS

#define w_cannon gamemodels "qp_cannon.mdl"
#define v_cannon gamemodels "qp_cannon.mdl"
CLASSDEF(weapon_class, weapon_cannon, "cannon")
WEAPONMODELS(w_cannon, v_cannon)
FLOAT(currentammo, 10)
rateoffire = 1;
attackvelocity = 60;
attacktimes = 1;
float(float times) attack = {return(hitscan(times)); };
ENDCLASS

#define w_sniper gamemodels "qp_m40a5.mdl"
#define v_sniper gamemodels "qp_m40a5.mdl"
CLASSDEF(weapon_class, weapon_sniper, "sniper")
WEAPONMODELS(w_sniper, v_sniper)
FLOAT(currentammo, 40)
rateoffire = 4;
attackvelocity = 120;
attacktimes = 1;
float(float times) attack = {return(hitscan(times)); };
ENDCLASS

#define w_rocket gamemodels "qp_rocket_launcher.mdl"
#define v_rocket gamemodels "qp_rocket_launcher.mdl"
CLASSDEF(weapon_class, weapon_rocket, "rocket launcher")
WEAPONMODELS(w_rocket, v_rocket)
FLOAT(currentammo, 10)
rateoffire = 1;
attackvelocity = 60;
attacktimes = 1;
float(float times) attack = {return(hitscan(times)); };
ENDCLASS

#define w_smg gamemodels "qp_sentinelsmg.mdl"
#define v_smg gamemodels "qp_sentinelsmg.mdl"
CLASSDEF(weapon_class, weapon_smg, "sentinel smg")
WEAPONMODELS(w_smg, v_smg)
FLOAT(currentammo, 140)
rateoffire = 8;
attackvelocity = 120;
attacktimes = 1;
float (float times) attack = {return(hitscan(times)); };
ENDCLASS

#define w_spear gamemodels "qp_spear.mdl"
#define v_spear gamemodels "qp_spear.mdl"
CLASSDEF(weapon_class, weapon_spear, "sentinel spear")
WEAPONMODELS(w_spear, v_spear)
FLOAT(currentammo, 40)
rateoffire = 1;
attackvelocity = 100;
attacktimes = 1;
float (float times) attack = {return(hitscan(times));};
ENDCLASS
