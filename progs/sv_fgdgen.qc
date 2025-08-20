//FGD class MACROS
#define BASEDEF(BASEname, BASEflags) {\
void() BASEname = {\
#message "#+FGD_base #BASEname"\
}
#define CLASSDEF(CLASSbase, CLASSname, CLASSdesc) {\
void() CLASSname = {\
CLASSbase();\
classname = "#CLASSname";\
#message "#+FGD_class #CLASSname"\
}
#define ENDCLASS };
#define FLOAT(FLOATfield, FLOATdesc, FLOATfloat) {\
if (!FLOATfield) FLOATfield = FLOATfloat;\
}
#define COLOR() /*do nothing*/
//fallback models
#define BMODEL(modelstring) {\
precache_model(modelstring);\
if (!this.model) setmodel(this, modelstring);}
#define VMODEL(modelstring) {\
precache_model(modelstring);\
if (!this.weaponmodel) this.weaponmodel = modelstring;}
//spawnfunctions
#define WEAPONMODELS(wmdl, vmdl) {\
precache_model(wmdl);\
precache_model(vmdl);\
setmodel(this, modelstring);\
weaponmodel = vmdl;}
