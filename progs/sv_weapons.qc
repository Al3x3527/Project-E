//weapon classes using class inheritance
#define w_placeholder "progs/mdls/w_placeholder.mdl"
#define v_placeholder "progs/mdls/v_placeholder.mdl"
#define w_assault "progs/mdls/w_AD70.mdl"
#define v_assault "progs/mdls/v_AD70.mdl"
#define w_plasrifle "progs/mdls/w_plasmarifle.mdl"
#define v_plasrifle "progs/mdls/v_plasmarifle.mdl"

class weapon : entity {

nonvirtual void(vector dir, float v) launch_projectile;
nonvirtual void weapon_use = //not weapon.use();
  {
    //check ammo
    if (!self.current_ammo) return;
//launch projectile at rate of fire = speed
    self.launch_projectile(dir, self.speed);
  };
virtual void() think =
  {//override conflicts in the spawn function
    ISCONSUMABLE
  };

BASEDEF(weapon, Spawnflags | Targetname) //only affects FGD.
if (SUB_Inhibit()) return;
nextthink = time + 0.3;
flags = FL_WEAPON;//field assigned in program
setsize (this, '-16 -24 0', '16 24 16');//field needed by FGD and engine
COLOR(206 18 18); //bbox color. does nothing in game (unless?)
BMODEL(w_placeholder)
VMODEL(v_placeholder)
ENDCLASS

CLASSDEF(weapon, weapon_assault, "assault rifle placed on map.")
WEAPONMODELS(w_assault, v_assault)
FLOAT(current_ammo, "starting ammo", 150)
//rate of fire (speed)
//projectile
//default respawn time
ENDCLASS

CLASSDEF(weapon, weapon_plasrifle, "plasma rifle placed on map.")
WEAPONMODELS(w_plasrifle, v_plasrifle)
FLOAT(current_ammo, "starting ammo", 140)
ENDCLASS

};
