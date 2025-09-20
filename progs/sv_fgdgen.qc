//FGD class MACROS
void(string text) fgdprint = {}; //exposes string in compiled program.
//void() spawnEverything = {}; //can this be done procedurally?
#define FGDbase(flags) fgdprint("@fgd @baseclass = base("#flags")");
//#define FGDfield(field, desc)
#define CLASSDEF(CLASSbase, CLASSname, CLASSdesc)\
class CLASSname : CLASSbase {\
void() CLASSname = {\
classname = #CLASSname;\
netname = #CLASSdesc;\
fgdprint("@fgd @Pointclass base("#CLASSbase") @fgd = "#CLASSname" : "#CLASSdesc"placed on map. [");

#define ENDCLASS fgdprint("@fgd ]");};}

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
fgdprint("@fgd model({ path :"gamemodels wmdl" })");\
precache_model(gamemodels wmdl);\
precache_model(gamemodels vmdl);\
setmodel(this, gamemodels wmdl);\
this.weaponmodel = gamemodels vmdl

#define WPCLASS(WPname, WPdesc)\
  runtime_t WPname ## _runtime;\
  class WPname : weapon_class {\
  virtual void(float times) attack = {WPname ## _attack(times);};\
  virtual void() equip = WEAPONEQUIP(WPname);\
  void() WPname = {\
  fgdprint("@fgd @Pointclass base(weapon_class) @fgd = "#WPname" : "#WPdesc"placed on map. [");\
  classname = #WPname;\
  netname = #WPdesc;\
  RUNTIME(WPname ## _runtime)

#define FLOAT(FLOATfield, FLOATfloat, FLOATdesc)\
if (!this.FLOATfield) this.FLOATfield = FLOATfloat;\
fgdprint("@fgd "#FLOATfield"(float) : "#FLOATdesc" : "#FLOATfloat)

#define STARTINGAMMO(startingammo) FLOAT(currentammo, startingammo, "starting ammo")

#define RESPAWNTIME(spawntime) FLOAT(respawntime, spawntime, "respawn time")

#define COLOR(color) fgdprint("@fgd color("#color")");

#define MODELdefault(modelstring) {\
precache_model(modelstring);\
if (!this.model) setmodel(this, modelstring);}
