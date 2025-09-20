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
  if !(other.primary) other.primary = new;\
  else if !(other.secondary) other.secondary = new;\
  else if (other.weapon == other.primary.weapon) other.primary = new;\
  else other.secondary = new;\
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
  fgdprint("@fgd @Pointclass base(weapon_class) @fgd = "#WPname" : "#WPdesc"placed on map. [");\
  virtual void(float times) attack = {WPname ## _attack(times);};\
  virtual void() equip = WEAPONEQUIP(WPname);\
  void() WPname = {\
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
