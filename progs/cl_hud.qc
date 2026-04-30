vector HUD_TEXT_1 = '1 1 1';
vector HUD_TEXT_MEDIUM = '16 16 0';

void(vector size) hud_test = {
  vector pos = '0 16 0';
  //health should be 100
  float health = getplayerstat(0, 0, EV_FLOAT);
  sui_push_frame(pos, size);
  sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
  sui_text([0,4], HUD_TEXT_MEDIUM, ftos(health), HUD_TEXT_1, 1, 0);
};
