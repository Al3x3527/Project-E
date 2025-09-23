//shared definitions

#define printf(x, ...) print(sprintf(x, __VA_ARGS__))


void() precache_everything =
{
	precache_sound("demon/dland2.wav");
	precache_model("models/testplayer.iqm");
	precache_sound("sounds/weapons/ar_shot.wav");
	precache_model("progs/s_explod.spr");
};
