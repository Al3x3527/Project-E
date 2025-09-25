void() weapon_print = {dprint("weapon_use\n");}

void(entity targ, entity inflictor, entity attacker, float damage) TakeDamage = {
//inflictor can = projectile
if !(targ) return;
targ.health -= damage;
entity oself = self;
self = targ;
if (targ.th_pain) targ.th_pain(inflictor, damage);
self = oself;
};

void(entity inflictor, entity attacker, float damage, float radius) TakeRadiusDamage = {
  float points;
  entity head;
  vector org;
//dprint("radius damage\n");
  if (!radius) radius = damage + 40;
  head = findradius(inflictor.origin, radius);

  while (head) {
    if (head) {
      org = head.origin + (head.mins + head.maxs)*0.5; //center
      points = 0.5*vlen(inflictor.origin - org);
      if (points < 0) points = 0;
      points = damage - points;
      if (head == attacker) points *= 0.5;
      if (points > 0) {
        TakeDamage(head, inflictor, attacker, points);
      }
    }
    head = head.chain;
  }
};

entity multi_ent;
float multi_damage;

void() ClearMultiDamage = //from Copper?
{
  multi_ent = world;
  multi_damage = 0;
};
void() ApplyMultiDamage = {
  //dprint(ftos(multi_damage)); dprint(" damage apply multi damage\n");
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

void(entity old) drop_weapon = {
  entity oself = self;
  self = old;
  setorigin(self, other.origin);
  self.spawnflags -= ITEM_HELD;
  self.use = PickupItem;
  self.touch = UseItemTry;
  RespawnItemDo();
  self = oself;
};

void(entity new) switch_weapon = {
 //expect other = player, self = new.enemy, on pickup
 self.weapon = new.weapon;
 self.active_weapon = new;
 //new.owner = other;
 self.weaponmodel = new.weaponmodel;
 self.currentammo = new.currentammo;
 self.weapon_use = use_active;
 new.impulse = time + 0.6;
 sprint(self, 1, "you switched to the ");
 sprint(self, 1, self.active_weapon.classname);
 sprint(self, 1, "!\n");
}
