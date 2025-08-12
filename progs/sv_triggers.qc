
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

void() test_think =
	{
		if (self.health < 30)
			{
				self.health += 1;
				self.nextthink = time + 1;
				return;
			}
		self.health = 0;
		dprint("test think");
	}

void() trigger_changelevel_touch =
	{
		dprint("trigger changelevel touched\n");
		sprint(other, 999, "trigger");
	}

void() trigger_changelevel =
{
	self.solid = SOLID_TRIGGER;
	self.touch = trigger_changelevel_touch;
	self.think = test_think;
	self.classname = "trigger_changelevel";
setmodel(self, self.model);
self.modelindex = 0;
self.nextthink = time + 1;
};
