const float WEAPON_BATTLERIFLE = 2;
const float WEAPON_PLASMARIFLE = 4;
const float WEAPON_BROWNING = 8;
const float WEAPON_CANNON = 16;
const float WEAPON_SNIPER = 32;
const float WEAPON_ROCKET = 64;
const float WEAPON_SMG = 128;
const float WEAPON_SPEAR = 256;

#define e_plasma gamemodels "qp_bomb.mdl"

void() projectile_touch = {
  if (other == self.owner) return;
  if (other.solid == SOLID_TRIGGER) return;
  float damage = self.health;
  entity ent = self.owner;
  //dprint(ftos(damage)); dprint("plasma touch tdamage\n");
  TakeDamage(other, self, ent, damage);
  remove(self);
};

void(entity ent, string path) weapon_sound = {
sound (ent, CHAN_WEAPON, path, 1, ATTN_NORM);
dprint(path); dprint(" weapon_sound\n");
};

class projectile_class : entity {
  float projectilespeed;
  void() projectile_class = {
    movetype = MOVETYPE_FLYMISSILE;
    solid = SOLID_TRIGGER;
    setmodel(this, e_plasma);
    touch = projectile_touch;
    projectilespeed = 200;
  };
};

class weapon_class : entity {
float attackvelocity;
float attacktimes;
float attackdamage;
float attackdelay;
float rateoffire; //burst
float ammo_clip; //burst

virtual void() attackdo = {dprint("placeholder attack\n");};

virtual void(vector dir, vector org, float damage, entity ent) projectile_spawn = {
  projectile_class proj = spawn(projectile_class);
  proj.origin = org;
  proj.velocity = dir * proj.projectilespeed;
  proj.health = damage;
  proj.owner = ent;
  dprint(ftos(damage)); dprint(" projectile\n");
};

virtual void() projectile = {
  entity ent = this.owner;
  vector org = ent.origin + '0 0 30';
  makevectors(ent.v_angle);
  vector dir = v_forward;
  float damage = this.attackdamage;
  projectile_spawn(dir, org, damage, ent);
};

 virtual void() weapon_plasmarifle_attack = {projectile();};
 virtual void() weapon_browning_attack = {};
 virtual void() weapon_cannon_attack = {};
 virtual void() weapon_sniper_attack = {};
 virtual void() weapon_rocket_attack = {};
 virtual void() weapon_smg_attack = {};
 virtual void() weapon_spear_attack = {};

 virtual void () hitscan = {
  float speed = this.attackvelocity;
  entity ent = this.owner;
  vector org = ent.origin + '0 0 30';
  makevectors(ent.v_angle);
  vector dir = v_forward;
  vector end = dir * 2048 + org;
  float flags = 0;
  ClearMultiDamage();
  traceline(org, end, flags, ent);
  weapon_sound(ent, "sounds/weapons/ar_shot.wav");
  //weapon_sound(ent, "weapons/ric1.wav");

  local float i = 0;
  if (trace_fraction != 1.0) {
    BulletHit(this.attackdamage, dir);
    dprint(trace_ent.classname); dprint("\n");
  }
  else dprint("hit nothing\n");
  ApplyMultiDamage();
 };

 virtual void() weapon_muse = {
   while (this.ammo_clip > 0){
     this.ammo_clip --;
     this.attack();
     this.nextthink = time + this.rateoffire;
     return;
   }
 };

 virtual void() weapon_use = {
  if (!this.currentammo) {
    dprint("no ammo!\n");
    return;
    }
  if (this.impulse > time) {
    return;
  }
  this.impulse = time + this.attackdelay;
    float times = this.attacktimes;
    if (this.currentammo == BOTTOMLESS_CLIP) times = 0; //not congruous
    if (this.currentammo != UNLIMITED_AMMO) this.currentammo -= times;{
      this.ammo_clip = times;
      this.think = weapon_muse;
      this.nextthink = time + rateoffire;
      }
    if (!this.currentammo) CONSUMEITEM
  };

void() weapon_class = {
FGDbase(Spawnflags Targetname)
COLOR(206 18 18)
//if (SUB_Inhibit()) return;
think = IsConsumable;
nextthink = time + 0.3;
setsize (this, '-16 -24 0', '16 24 16');
void() attack = attackdo;
precache_model(gamemodels "qp_bomb.mdl");
};
};

runtime_t weapon_battlerifle_runtime;
class weapon_battlerifle : weapon_class {
virtual void() attack = {hitscan();};
virtual void() equip = WEAPONEQUIP(weapon_battlerifle);
void () weapon_battlerifle = {
  classname = "weapon_battlerifle";
WEAPONMODELS("w_ad70.mdl", "v_ad70.mdl");
FLOAT(currentammo, 150, "starting ammo");
weapon = WEAPON_BATTLERIFLE;
attackvelocity = 120;
attacktimes = 3;
attackdamage = 20;
attackdelay = 0.8;
rateoffire = 0.1;
RUNTIME(weapon_battlerifle_runtime);
RESPAWNTIME(40);
dprint("weapon_battlerifle spawn function\n");
};
};

WPCLASS(weapon_plasmarifle, "plasma rifle");
WEAPONMODELS("w_plasma_rifle.mdl", "v_plasma_rifle.mdl");
STARTINGAMMO(140);
RESPAWNTIME(40);
weapon = WEAPON_PLASMARIFLE;
attackvelocity = 80;
attacktimes = 3;
attackdelay = 0.8;
attackdamage = 20;
ENDCLASS;

WPCLASS(weapon_browning, "machine gun");
WEAPONMODELS("browning.mdl", "browning.mdl");
STARTINGAMMO(400);
RESPAWNTIME(40);
weapon = WEAPON_BROWNING;
attackvelocity = 120;
attacktimes = 1;
attackdelay = 0.2;
attackdamage = 20;
ENDCLASS;

WPCLASS(weapon_cannon, "sentinel cannon");
WEAPONMODELS("qp_cannon.mdl", "qp_cannon.mdl");
STARTINGAMMO(10);
RESPAWNTIME(40);
weapon = WEAPON_CANNON;
attackvelocity = 60;
attacktimes = 1;
attackdelay = 0.6;
ENDCLASS;

WPCLASS(weapon_sniper, "sniper");
WEAPONMODELS("qp_m40a5.mdl", "qp_m40a5.mdl");
STARTINGAMMO(40);
RESPAWNTIME(40);
weapon = WEAPON_SNIPER;
attackvelocity = 120;
attacktimes = 1;
attackdelay = 0.6;
ENDCLASS;

WPCLASS(weapon_rocket, "rocket launcher");
WEAPONMODELS("qp_rocket_launcher.mdl", "qp_rocket_launcher.mdl");
STARTINGAMMO(10);
RESPAWNTIME(40);
weapon = WEAPON_ROCKET;
attackvelocity = 60;
attacktimes = 1;
attackdelay = 0.6;
ENDCLASS;

WPCLASS(weapon_smg, "sentinel smg");
WEAPONMODELS("qp_sentinelsmg.mdl", "qp_sentinelsmg.mdl");
STARTINGAMMO(140);
RESPAWNTIME(40);
weapon = WEAPON_SMG;
attackvelocity = 120;
attacktimes = 1;
attackdelay = 0.2;
ENDCLASS;

WPCLASS(weapon_spear, "sentinel spear");
WEAPONMODELS("qp_spear.mdl", "qp_spear.mdl");
STARTINGAMMO(40);
RESPAWNTIME(40);
weapon = WEAPON_SPEAR;
attackvelocity = 100;
attacktimes = 1;
attackdelay = 0.6;
ENDCLASS;
