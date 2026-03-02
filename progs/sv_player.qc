
//
//	Player.qc - Various stuff done for the player, including per-frame functions like PlayerPreThink and PlayerPostThink, also client specific stuff like PutClientInServer etc.
//

void() PlayerJump =
{
	/* jump energy
	if (!(self.flags & FL_ONGROUND))
		return; */
	if (!(self.ammo_rockets > 0))
		return;
	if ( !(self.flags & FL_JUMPRELEASED) )
		return;
	float boost = self.ammo_rockets;
	self.ammo_rockets -= 170;
	//dprint(strcat("jump energy", ftos(self.ammo_rockets), "\n"));
	//dprint(strcat("velocity", vtos(self.velocity), "\n"));
	if (!(self.flags & FL_ONGROUND)) {
		//air control
		vector vyaw = self.v_angle;
		vyaw.x = vyaw.z = 0;
		makevectors(vyaw);
		vector vel = self.velocity;
		vector vxy = vel;
		vxy.z = 0;
		vxy = vlen(vxy) * v_forward;
		self.velocity.x = vxy.x;
		self.velocity.y = vxy.y;
		//loose nothing
		if (vel.z > 0) self.velocity.z += boost;
		else self.velocity.z = boost * 1.3; //spoof on ground instead?
	}
	//boost for jumping into wall (feel good)?

	self.weaponframe = 0;
	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
	self.button2 = 0;
};

void() CheckImpulses =
{
	switch (self.impulse)
	{
	case 2: if(self.primary) switch_weapon(self.primary); break;
	case 3: if (self.secondary) switch_weapon(self.secondary); break;
	default: break;
	}
//	self.impulse = 0;
};

vector() get_spawn_point =
{
	entity spawnpoint = world;
	spawnpoint = find(spawnpoint, classname, "info_player_start");

	return spawnpoint.origin + '0 0 1';
};

void() PlayerPreThink =
{	
	CheckImpulses();
	makevectors(self.v_angle);
	if(self.button0)
	{
		if(self.weapon_use) self.weapon_use();
	}
	if(self.button2)
	{
		PlayerJump();
	}
	else
	{
		self.flags = self.flags | FL_JUMPRELEASED;
	}
	//dprint(strcat("player health ", ftos(self.health), "\n"));
};

void() PlayerPostThink =
{
	self.impulse = 0;
	//jump energy
	if (self.flags & FL_ONGROUND) self.ammo_rockets = 340;
};

void() ClientKill =
{
};

//called when a client connects to the server
void() ClientConnect =
{
	// print("Client connect\n");
};

void() PlayerSpawn =
{
	self.classname = "player";
	self.solid = SOLID_SLIDEBOX;
	setmodel(self, gamemodels "police.mdl");
	self.movetype = MOVETYPE_WALK;
	self.health = 100;
	setorigin(self, get_spawn_point());
	self.fixangle = TRUE;
	setsize(self, [-16, -16, 0], [16, 16, 56]);
	self.view_ofs = [0, 0, 48];

	self.team = TEAM_NATO;//placeholder
	self.flags = FL_CLIENT;
	self.scary = 2; //idk
};

void() PutClientInServer =
{
	player_chain_add(self);
	PlayerSpawn();
};

void() ClientDisconnect =
{
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " has left the game.\n");
};


void() SetNewParms =
{
};

void() SetChangeParms =
{
};

INFO(info_player_start, "Spawnflags", "initial spawn point");

void(float elapsedtime) SV_PausedTic =
{
	// if (elapsedtime > 2) setpause(0);
};

void(string command_string) SV_ParseClientCommand =
{
	tokenize(command_string);
	string cmd = argv(0);
	switch (cmd)
	{
	default: break;
	}
	clientcommand(self, command_string);
};


void() SV_RunClientCommand =
{
	runstandardplayerphysics(self);
};


