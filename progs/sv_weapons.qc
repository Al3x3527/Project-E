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
FLOAT(currentammo, "starting ammo", 150)
rateoffire = 8;
attackvelocity = 120;
attacktimes = 1;
float(float times) attack = { return(hitscan(times)); };

//default respawn time
dprint("weapon_battlerifle spawn function\n");
};
};
