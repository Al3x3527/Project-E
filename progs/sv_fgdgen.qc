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
dprint("net name"); dprint(netname);\
fgdprint("@fgd @Pointclass base("#CLASSbase") @fgd = "#CLASSname" : "#CLASSdesc" [");
//fgd description = #CLASSdesc placed on map.
/*#message "#+FGD_class #CLASSname"*/
#define ENDCLASS fgdprint("@fgd ]");};};
#define FLOAT(FLOATfield, FLOATfloat, FLOATdesc) {\
if (!this.FLOATfield) this.FLOATfield = FLOATfloat;\
fgdprint("@fgd "#FLOATfield"(float) : "#FLOATdesc" : "#FLOATfloat);}
#define COLOR(color) fgdprint("@fgd color("#color")");
//fallback models
#define MODELdefault(modelstring) {\
precache_model(modelstring);\
if (!this.model) setmodel(this, modelstring);}
//spawnfunctions
#define WEAPONMODELS(wmdl, vmdl) {\
fgdprint("@fgd model({ path :"wmdl" })");\
precache_model(wmdl);\
precache_model(vmdl);\
setmodel(this, wmdl);\
this.weaponmodel = vmdl;}
