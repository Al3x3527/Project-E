//FGD class MACROS
#define FGDbase(flags)
#define CLASSDEF(CLASSbase, CLASSname, CLASSdesc)\
class CLASSname : CLASSbase {\
void() CLASSname = {\
classname = "#CLASSname";\
/*#message "#+FGD_class #CLASSname"*/
#define ENDCLASS };
#define FLOAT(FLOATfield, FLOATdesc, FLOATfloat) {\
if (!this.FLOATfield) this.FLOATfield = FLOATfloat;}
#define COLOR() /*do nothing*/
//fallback models
#define MODELdefault(modelstring) {\
precache_model(modelstring);\
if (!this.model) setmodel(this, modelstring);}
//spawnfunctions
#define WEAPONMODELS(wmdl, vmdl) {\
precache_model(wmdl);\
precache_model(vmdl);\
setmodel(this, wmdl);\
this.weaponmodel = vmdl;}
