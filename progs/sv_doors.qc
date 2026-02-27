/*sv_doors.qv
 borrows heavily from progs_dump doors.qc and keylock.qc */
enum float
{
  DOOR_START_OPEN,
    DOOR_DONT_LINK,
    //DOOR_GOLD_KEY,
    //DOOR_SILVER_KEY,
    DOOR_TOGGLE,
    DOOR_DOOM_STYLE_UNLOCK
};

enum float
{
  STATE_TOP,
    STATE_BOTTOM,
    STATE_DOWN,
    STATE_UP
};

float STATE_ACTIVE = 0; //convention
float STATE_INACTIVE = 1;
float FINAL_CUSTOM_KEY = 4194304;
float highest_custom_key;

void() SUB_CalcMoveDone = {
  setorigin(self, self.lastseen);
  self.velocity = '0 0 0';
  self.nextthink = -1;
  self.equip();
}

void(vector tdest, float tspeed, void() func) SUB_CalcMove = {
  dprint("SUB_CalcMove\n");
  vector vdestdelta;
  float len, traveltime, localtime;
  if !(tspeed) objerror("No speed is defined!");
  if (self.movetype == MOVETYPE_PUSH) localtime = self.ltime;
  else localtime = time;
  self.think = SUB_CalcMoveDone;
  self.equip = func;
  self.lastseen = tdest;
  if(tdest == self.origin){
    self.velocity = '0 0 0';
    self.nextthink = localtime + 0.1;
    return;
  }
  vdestdelta = tdest - self.origin;
  len = vlen(vdestdelta);
  traveltime = len / tspeed;
  if (traveltime < 0.1) {
    self.velocity = '0 0 0';
    self.nextthink = localtime + 0.1;
    return;
  }
  self.nextthink = localtime + traveltime;
  self.velocity = vdestdelta * (1/traveltime);

}

class item_key : entity {
  //float customkeys; items
  virtual void() use = { //changed from touch
    if (other.items & items) return; //has keys
    other.items += items; //give keys
    //activator = other;
    use();
  };
  void() item_key = {
    setmodel(this, gamemodels "qp_bomb.mdl");
    if (target == "") {
      objerror("key no target");
      return;
    }
    netname = target;
    setsize(this, '-16 -16 -24', '16 16 32');
    if !(items) { //just set it ourselves TODO
        objerror("key no item");
        return;
      }
    //IsItem();
    //IsAutoPickup();
    //FIXME IsKey to find doors?
    //keylock_set_custom_key(target);
    think = IsKey;
    nextthink = time + 0.3;
    fgdprint("@fgd\n@Pointclass base(Spawnflags, Target) color(0 0 255) = item_key : \"key item placed on map\" [");
  };
};

float (string key_name) CustomKeyFlag = {
  item_key key_def = find(world, target, key_name);
  //TODO: check for unused .items bitflag
  if !(key_def.items) {objerror("custom key flags no items");  return(0);}
  dprint(strcat("CustomKeyFlag ", ftos(key_def.items), "\n"));
  return(key_def.items);
}

void(string key_name) keylock_set_custom_key = {
  dprint("keylock_set_custom_key\n");
  self.items = CustomKeyFlag (key_name);
  self.netname = key_name;
  //FIXME: assign items to all targets
  entity door0 = find(world, targetname, key_name);
  if (door0) {
    entity door = door0;
    } else objerror("custom key no doors");
  while (door){
    dprint(strcat("door found for ", key_name, "\n"));
    door.items = self.items;
    door.netname = self.netname;
    door = find(door, targetname, key_name);
    if !(door) break;
    if (door == door0) break;
  }
}
float() keylock_has_key_set = {
  if (self.items) dprint(strcat("keylock has key ", ftos(self.items), "\n"));
  return (self.items != 0);
};
void(entity client, string custom_message, void() success_func) keylock_try_to_unlock ={
  dprint("keylock_try_to_unlock\n");
  string s;
  if !(client.items & self.items) {
    if (custom_message != "") centerprint (client, custom_message);
    else centerprint (client, strcat( "You need the ", self.netname));
    return;
  }
  client.items -= self.items;
  s = "You used the ";
  sprint(client, 1, s);
  sprint(client, 1, self.netname);
  sprint(client, 1, "\n");
  success_func ();
};

void() trigger_door_use = {
  if !(self.owner) return;
  self = self.owner;
  //NOTE: field should not spawn if key door
  self.use();
};

class func_door_trigger : entity {
  virtual void() touch = {
    if (other.health <= 0) return;
    if (other.movetype == MOVETYPE_NOCLIP) return;
    if (time < impulse) return;
    impulse = time + 1;
    use();
  };
  void() func_door_trigger = {
    movetype = MOVETYPE_NONE;
    solid = SOLID_TRIGGER;
    use = trigger_door_use;
  };
};

class func_door : entity {
  float state;
  vector pos1;
  vector pos2;
  float speed;
  float prevstate;

  nonvirtual void() door_go_down;
  nonvirtual void() door_go_up;

  nonvirtual void() door_hit_top = {
    state = STATE_TOP;
    if (spawnflags & DOOR_TOGGLE) return;
    think = door_go_down;
    nextthink = ltime + wait;
  };

  nonvirtual void() door_hit_bottom = {
    state = STATE_BOTTOM;
  };

  nonvirtual void() door_go_down = {
    //deal with shadows later
    state = STATE_DOWN;
    SUB_CalcMove (pos1, speed, door_hit_bottom);
  };

  nonvirtual void() door_go_up = {
    if (state == STATE_UP) return;
    if (state == STATE_TOP) {
      nextthink = ltime + wait;
      return;
    }
    state = STATE_UP;
    SUB_CalcMove (pos2, speed, door_hit_top);
    //SUB_UseTargets();
  };

  nonvirtual void() door_fire = {
    dprint("door fire\n");
    dprint(strcat("movedir ", vtos(movedir), "\n"));
    if (owner != this) objerror("door_fire: owner != this");
    if (estate != STATE_ACTIVE) {
      dprint("estate != STATE_ACIVE\n");
      return; }
    message = "";
    if (spawnflags & DOOR_TOGGLE) {
      if (state == STATE_UP || state == STATE_TOP) {
        door_go_down(); //door_group_go_down
        return;
      }
    }
    door_go_up();
  };

  virtual void() use = {
    dprint("door: use\n");
    message = "";
    if (owner)
      owner.message = "";
    if (enemy)
      enemy.message = "";
    //self = self.owner for group
    door_fire();
  };

  nonvirtual void() door_unlock = {
    if (!(spawnflags & DOOR_DOOM_STYLE_UNLOCK)) {
      touch = sub_noop;
      if (enemy) enemy.touch = sub_noop;
    }
    use();
  };

  virtual void() touch = {
    //doors without keys are opened with door_trigger_touch
    if (impulse > time) return;
    dprint("door: touch\n");
    impulse = time + 2;
    if (message != "") {
      centerprint (other, message);
    }
    if (!keylock_has_key_set ()){ //if no key set
      dprint("door: touch no key\n");
      return; }
    //NOTE: door otherwise opens with trigger volume
    keylock_try_to_unlock (other, "", door_unlock);
  };

  void() func_door = {
    setmodel(this, this.model);
    solid = SOLID_BSP;
    movetype = MOVETYPE_PUSH;
    FUNC(func_door, "Targetname", "door brush");
    //TODO
    owner = this;
    if !(movedir) movedir = '1 0 0'; //no quotes in editor

    //TODO: fgdgen
    if !(speed) speed = 100;
    if !(wait) wait = 3;
    //if !(lip) lip = 8;
    //if !(dmg) dmg = 2;
    pos1 = origin;
    pos2 = pos1 + movedir*(fabs(movedir*size) - 8); //- lip

    if (spawnflags & DOOR_START_OPEN) {
        setorigin(this, pos2);
        pos2 = pos1;
        pos1 = origin;
      }
    state = STATE_BOTTOM;
/*    if (health) {
      takedamage = DAMAGE_YES;
      th_die = door_killed;
    }
*/
    //dont spawn field if key door
    if (health) return;
    if (targetname != "") return;
    if (keylock_has_key_set ()) return; //possibly redundant

    func_door_trigger trigger = spawn(func_door_trigger);
    trigger.owner = this;
    setsize(trigger, mins - '60 60 8', maxs + '60 60 8');
  };
};

void(func_door e, float closealldoors) door_estate_lock = {
  func_door oself, next, test;
  if (e.owner.estate == STATE_INACTIVE) return;
  //blocks repeating somehow
  if (e.owner.goalentity == self && e.owner.teleport_time == time) return;
  oself = self;
  test = e.owner;
  test.estate = STATE_INACTIVE;
  test.goalentity = oself;
  test.teleport_time = time;
  test.prevstate = test.state;
  if (test.state == STATE_UP || test.state == STATE_TOP) {
    if (!(test.wait == -1 || (test.spawnflags & DOOR_TOGGLE)) || closealldoors){
      self = test;
      test.door_go_down();
      }
  }
  if (test.max_health) {
    next = test;
    do {
      next.takedamage = DAMAGE_NO;
      next = next.enemy;
    } while ((next != test) && (next != world));
  }
  self = oself;
}
