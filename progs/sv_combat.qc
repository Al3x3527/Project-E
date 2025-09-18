void() weapon_print = {dprint("weapon_use\n");}

void(entity targ, entity inflictor, entity attacker, float damage) TakeDamage = {
//inflictor can = projectile
targ.health -= damage;
entity oself = self;
self = targ;
targ.th_pain(inflictor, damage);
self = oself;
//dprint(ftos(targ.health));
//dprint(" targ health\n");
};

entity multi_ent;
float multi_damage;

void() ClearMultiDamage = //from Copper?
{
  multi_ent = world;
  multi_damage = 0;
};
void() ApplyMultiDamage = {
  dprint(ftos(multi_damage)); dprint(" damage apply multi damage\n");
  if(!multi_ent) return;
  TakeDamage(multi_ent, other, other, multi_damage);
};
void(entity hit, float damage) AddMultiDamage = {
  if (!hit) return;
  if (hit != multi_ent)
    {
      ApplyMultiDamage();
      multi_damage = damage;
      multi_ent = hit;
    }
  else multi_damage += damage;
};

void(float damage, vector dir) BulletHit = {
  //other should be shooter
  AddMultiDamage(trace_ent, damage);
};

class func_target: entity {
  nonvirtual void(entity inflictor, float damage) targ_pain = {
    dprint("target hit "); dprint(ftos(this.health)); dprint(" health\n");
  };
  nonvirtual void() targ_touch = {dprint(ftos(this.health)); dprint("debug\n");};
  void() func_target = {
    classname = "func_target";
    solid = SOLID_BSP;
    health = 100;
    setmodel(this, this.model);
    touch = targ_touch;
    th_pain = targ_pain;

  };
};

void() use_active = {
  other = self;
  self = self.active_weapon;
  self.weapon_use();
  self = other;
  //old other lost
  return;
}

void(entity new) switch_weapon = {
 //expect other = player, self = new.enemy
 other.weapon = new.weapon;
 other.active_weapon = new;
 new.owner = other;
 other.weaponmodel = new.weaponmodel;
 other.currentammo = new.currentammo;
 other.weapon_use = use_active;
 new.impulse = time + 0.6;
 sprint(other, 1, "you switched to the ");
 sprint(other, 1, new.classname);
 sprint(other, 1, "!\n");
}
