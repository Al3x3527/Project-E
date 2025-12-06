 float(float spawns) spawner_use = {
    //self = spawner
    entity startingpoint = self.enemy; //last point
    entity test = startingpoint;
    float flag = 0;
    float i;
    float newspawns = 0;
    entity monster;
    float tstyle = self.style;
    while (spawns > 0) {
      monster = FALSE;
      if !(test.enemy) break;
      test = test.enemy; //spawn point linking
      if (test == startingpoint) break;
      //we have our spawn point
      i = SEN_ELITE;
      while (tstyle ^- i) i /= 2;
      if (i > 4) flag = i;
      else if !(flag) break; //no style flags found
      //we have our largest style flag
      switch (flag) { //choose a spawn class
      case MAN_GRUNT..MAN_HEAVY : monster = spawn(biped_man); break;
      case MAN_ELITE : break;
      case PAN_GRUNT..PAN_ELITE : break;
      case DRA_GRUNT..DRA_ELITE : break;
      case FRO_GRUNT..FRO_ELITE : break;
      case WIG_ULTRA : break;
      case FPV_GRUNT..FPV_HEAVY : break;
      case FPV_ELITE : break;
      case FPV_ULTRA : break;
      case ZOM_GRUNT : break;
      case ZOM_HEAVY : break;
      case ZOM_ELITE : break;
      case ZOM_ULTRA : break;
      case SEN_GRUNT..SEN_ELITE : break;
      default : break;
      }
      setorigin(monster, test.origin);
      monster.style = flag;
      monster.flags += FL_MONSTER;
      tstyle -= flag; //NOTE float precision jank in |= over 23 bits
      newspawns ++;
      spawns --;
    }
    monsters_runtime.runtime_current += newspawns;
    return(spawns);
  };
