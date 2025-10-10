
/*
void() trigger_example =
{
	setmodel(self, self.model);
	self.modelindex = 0;
	self.solid = SOLID_TRIGGER;
	self.touch = something;
};
*/

void() info_null =
{
};

void() func_illusionary =
{
	setmodel(self, self.model);
	self.solid = SOLID_NOT;
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
};

void() trigger_zone = {
	setmodel(self, self.model);
	self.modelindex = 0;
};
