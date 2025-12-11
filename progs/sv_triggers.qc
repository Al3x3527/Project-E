
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
	if !(use_ent) return;
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

//trigger zone in combat.qc

void() func_door = {
	setmodel(self, self.model);
	self.solid = SOLID_BSP;
	FUNC(func_door, "Targetname", "door brush");
};

void() item_key = {
	fgdprint("@fgd\n@Pointclass base(Spawnflags, Target) color(0 0 255) = item_key : \"key item placed on map\" [");
};

class func_decoration : entity {
	void() func_decoration = {
		setmodel(this, this.model);
		solid = SOLID_BSP;
	};
};

class func_breakable : func_decoration {
	void() func_breakable = {
	FUNC(func_breakable, "Spawnflags", "breakable brush");
	FLOAT(health, 20, "starting health value");
};

};
