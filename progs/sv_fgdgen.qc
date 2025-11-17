//FGD class MACROS
void(string text) fgdprint = {}; //exposes string in compiled program.
//void() spawnEverything = {}; //can this be done procedurally?
#define FGDbase(flags) fgdprint("@fgd \n@baseclass = base("#flags")");
//#define FGDfield(field, desc)
#define CLASSDEF(CLASSbase, CLASSname, CLASSdesc)\
class CLASSname : CLASSbase {\
void() CLASSname = {\
classname = #CLASSname;\
netname = #CLASSdesc;\
fgdprint("@fgd \n@PointClass base("#CLASSbase") "#CLASSname" :\n"#CLASSdesc"placed on map.\n [");

#define ENDCLASS fgdprint("@fgd \n]");};}

#define WEAPONEQUIP(aclass) {\
 aclass new = spawn(aclass);\
  new.spawnflags = this.spawnflags;\
  new.currentammo = this.currentammo;\
  new.enemy = this;\
  new.solid = SOLID_NOT;\
  new.owner = other;\
  new.modelindex = 0;\
  if !(other.primary) {other.primary = new;\
    dprint("new primary "); dprint(other.primary.classname); dprint("\n");}\
  else if !(other.secondary) {other.secondary = new;\
    dprint("new secondary "); dprint(other.secondary.classname); dprint("\n");}\
  else if (other.weapon == other.primary.weapon){ drop_weapon(other.primary);\
    other.primary = new;\
    dprint("swap primary\n");}\
  else {drop_weapon(other.secondary);\
    other.secondary = new;\
    dprint("swap secondary\n");}\
  this = other;\
  switch_weapon(new);\
}

#define WEAPONMODELS(wmdl, vmdl)\
fgdprint("@fgd\n model({ path :"gamemodels wmdl" })");\
precache_model(gamemodels wmdl);\
precache_model(gamemodels vmdl);\
setmodel(this, gamemodels wmdl);\
this.weaponmodel = gamemodels vmdl

#define WPCLASS(WPname, WPdesc)\
  runtime_t WPname ## _runtime;\
  class WPname : weapon_class {\
  virtual void() attack = {WPname ## _attack();};\
  virtual void() equip = WEAPONEQUIP(WPname);\
  void() WPname = {\
  fgdprint("@fgd \n@PointClass base(weapon_class) = "#WPname" :\n"#WPdesc" placed on map.\n [");\
  classname = #WPname;\
  netname = #WPdesc;\
  RUNTIME(WPname ## _runtime)

#define FLOAT(FLOATfield, FLOATfloat, FLOATdesc)\
if (!this.FLOATfield) this.FLOATfield = FLOATfloat;\
fgdprint("@fgd \n "#FLOATfield"(float) : "#FLOATdesc" : "#FLOATfloat)

#define STARTINGAMMO(startingammo) FLOAT(currentammo, startingammo, "starting ammo")

#define RESPAWNTIME(spawntime) FLOAT(respawntime, spawntime, "respawn time")

#define COLOR(color) fgdprint("@fgd\n color("#color")")

#define MODELdefault(modelstring) {\
precache_model(modelstring);\
if (!this.model) setmodel(this, modelstring);}

#define BPCLASS(BPname, BPdesc)\
  runtime_t BPname ## _runtime;\
  class BPname : biped_class {\
  void() BPname = {\
  fgdprint("@fgd \n@PointClass base(biped_class) = "#BPname" : "#BPdesc" placed on map.\n [");\
  classname = #BPname;\
  netname = #BPdesc;\
  RUNTIME(BPname ## _runtime)

#define ENTMODEL(amodel)\
  fgdprint("@fgd\n model({ path :"gamemodels amodel" })");\
  precache_model(gamemodels amodel);\
  setmodel(this, gamemodels amodel)

#define BPTHINK(nick)\
  th_stand = nick ## _stand1;\
  th_walk = nick ## _walk1;\
  th_run = nick ## _run1;\
  th_pain = nick ## _pain1;\
  th_die = nick ## _die1;\
  th_charge = nick ## _charge1;\
  th_shoot = nick ## _shoot1;\
  th_melee = nick ## _melee1;\
  th_bark = nick ## _bark1;\
  th_reload = nick ## _reload1;\
  th_aggro = nick ## _aggro1;\
  th_evade = nick ## _evade1;\
  th_grenade = nick ## _grenade1;\
  th_board = nick ## _board1;\
  th_unboard = nick ## _unboard1;\
  th_crouch = nick ## _crouch1;\
  th_shield = nick ## _shield1;\
  th_jump = nick ## _jump1;\
  th_drive = nick ## _drive1;\
  th_turret = nick ## _turret1;\
  th_uncover = nick ## _uncover1;\
  th_avoid = nick ## _avoid1;\
  th_sleep = nick ## _sleep1;\
  th_alert = nick ## _alert1;\
  th_flee = nick ## _flee1;\
  th_converse = nick ## _converse1
