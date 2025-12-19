void() weapon_print = {dprint("weapon_use\n");}

void() MonsterDie = {
  if (monsters_runtime.runtime_current > 0) monsters_runtime.runtime_current -= 1;
};

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

class firingpoint_c : entity {
  string firinggroup;

  nonvirtual void() point_touch = {
    dprint("firing point touch\n");
    if (other.goalentity != this) return;
    other.goalentity = world;
    other.think = other.th_stand;
  };
  virtual void() think = {
    dprint("firing point removed\n");
    remove(this); //for cover points
  };
  void() firingpoint_c = {
    touch = point_touch;
    solid = SOLID_TRIGGER;
    setsize(this, '-8 -8 0', '8 8 16');
    firinggroup = targetname;
  };
};

class info_firingpoint : firingpoint_c {
  void() info_firingpoint = {
    INFO(info_firingpoint, "Spawnflags", "firing point placed on map.")
    STRING(targetname, target_source, "firing group");
  };
};

class trigger_zone : entity {
  firingpoint_c point0;
  firingpoint_c point1;
  firingpoint_c point2;
  firingpoint_c point3;
  firingpoint_c point4;
  firingpoint_c point5;
  firingpoint_c point6;
  firingpoint_c point7;
  //firingpoint_c point8;
  //firingpoint_c point9;
  //firingpoint_c point10;
  //firingpoint_c point11;
  //firingpoint_c point12;
  //firingpoint_c point13;
  //firingpoint_c point14;
  //firingpoint_c point15;
  void() trigger_zone = {
    setmodel(this, this.model);
    setorigin(this, this.origin + '0 0 16');
    modelindex = 0;
	FUNC(trigger_zone, "trigger_multiple", "trigger zone brush");
  };
};

entity (string name) findtarget = {
  //string name = self.target;
  return(find(world, targetname, name));};
entity (entity start, string name) findmoretargets = {
  return(find(start, targetname, name));};
entity (string name) findcontroller = {
  entity test = find(world, target, name);
  if (self == test) { test = find(test, target, name); }
  if (test.classname == test.classname) {dprint("err no controller\n"); return FALSE;}
  return (test);
};

int (entity e) CheckDist = {
  vector vec = e.origin - self.origin;
  float len = vlen(vec);
  if (len < 16) return(DIST_KREIG);
  if (len < 64) return(DIST_NEAR);
  if (len < 256) return(DIST_MED);
  return(DIST_FAR);
};

class path_search : entity {
  //style SEARCH_X
  //weapon
  //team
  //origin
  //enemy lookingfor
  virtual void() think = {
    if (this.style == SEARCH_SCRIPTED) return;
    this.enemy = world;
    remove(this);
  };
  virtual void() touch = {
    if (other.goalentity != this) return;
    this.enemy = world;
    other.think = other.th_fooled;
    other.goalentity = world;
    remove(this);
  };
  void() path_search = {
    nextthink = time + 15;
    classname = "path_search";
    flags = FL_SEARCHPOINT;
  };
};

class path_cover : entity {
  virtual void() touch = {
    if (other.goalentity != this) return;
    other.think = other.th_cover;
  };
  virtual void() think = {
    remove(this); //for temporary NOTE: use firingpoint
  };
  void() path_cover = {
    flags = FL_COVER;
  };
};

void() hint_touch = {
  if (other.flags & FL_CORNER) return;
  other.goalentity = self.enemy;
  dprint("hint touched\n");
};

void() hint_think = {
  self.enemy = findtarget(self.target);
  if !(self.enemy) self.touch = sub_noop;
}

void() trigger_hint = {
  setmodel(self, self.model);
  self.modelindex = 0;
  self.solid = SOLID_TRIGGER;

  self.touch = hint_touch;
  self.think = hint_think;
  self.nextthink = time + 0.3;
  FUNC(trigger_hint, "Target", "navigation hint.");
};

class path_corner : entity {
  //NOTE view_ofs = fwd, r, tp firing point org
  virtual void() touch = {
    if (other.goalentity != this) return;
    if !(other.flags & FL_CORNER) other.flags += FL_CORNER;
    dprint("corner touch\n");
    other.goalentity = FALSE;
    if (this.target != FALSE) {
      entity targ = findtarget(this.target);
      if (targ) other.goalentity = targ;
      return;
    }

    //other.think = other.th_wait;
    other.wait = this.wait;
  };
  void() path_corner = {
    //wait = 1;
    flags = FL_COVER;
    setsize(self, '-8 -8 -8', '8 8 16');
    solid = SOLID_TRIGGER;
    FGDbase("Spawnflags, Target, Targetname", Path, "path point classes for biped navigation");
    COLOR(0 255 221);
    PATH(path_corner, "Path", "corner marker for biped navigation");
  };
};
