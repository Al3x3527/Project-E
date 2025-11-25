
/*
void() trigger_example =
{
	setmodel(self, self.model);
	self.modelindex = 0;
	self.solid = SOLID_TRIGGER;
	self.touch = something;
};
*/

INFO(info_null, "Spawnflags", "info null");

void() func_illusionary =
{
	setmodel(self, self.model);
	self.solid = SOLID_NOT;
	FUNC(func_illusionary, "ModelLight", "non-solid brush");
};

void() UseTarget = {
	entity use_ent = find(world, targetname, self.target);
	entity oself = self;
	self = use_ent;
	other = self;
	self.use();
	self = oself;
};

void() trigger_multiple = {
	setmodel(self, self.model);
	self.modelindex = 0;
	self.solid = SOLID_TRIGGER;
	self.touch = UseTarget;
	FUNC(trigger_multiple, "Target", "trigger multiple brush");
};

//trigger zone in enemies.qc
