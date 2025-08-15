//weapon classes using class inheritance

void(float metaclass) base = { //should only impact FGD but exposed to game
  if (metaclass && Spawnflags){
    spawnflags = { //field = flag : desc optional: default syntax.
    //(type) redundant here.
    4 : "dont place at start" : 0;
    }
  }
  if (metaclass && Targetname){
  targetname : "target name"; //field : desc optional: default syntax.
  }
}

vector(float r = 0, float g = 0, float b = 0) color = {
  return ('r g b'); //might as well
}

class weapon : entity {
 flags = FL_WEAPON;//field assigned in program
 size = '16 24 16';//field needed by FGD and engine
 color(206 18 18); //bbox color. does nothing in game (unless?)
 base(Spawnflags & Targetname); //only affects FGD.
};

//valid syntax
class weapon_assault : weapon {
classname = "weapon_assault";
if (!current_ammo) {current_ammo = 70;}// normal style
}

//for FGD parity/tools
//descriptions not compiled, reference only
class weapon_assault : weapon : "assault rifle placed on map." { //optional description
  classname = "weapon_assault"; //field assigned in program
  current_ammo : "starting ammo (default 150)" : 150; //default value used by game
};

/* void() weapon_assault =
  {
    weaponAssault new = spawn();
    //current_ammo set in editor should be passed in automatically?
  }
 class constructor will double as spawn function */
