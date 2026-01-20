// Empty

vector HUD_TEXT_1 = '1 1 1';
vector HUD_TEXT_MEDIUM = '16 16 0';

void(vector size) hud_test = {
  vector pos = '0 16 0';
  //vector size;
  sui_push_frame(pos, size);
  sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
  sui_text([0,4], HUD_TEXT_MEDIUM, "test", HUD_TEXT_1, 1, 0);
};
