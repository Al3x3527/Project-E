// put custom server-only globals and fields here

const float FL_JUMPRELEASED = 4096;

void() sub_remove =
{
	remove(self);
};

void() sub_noop = {};

void(float event) BeginEvent =
{
	WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET);
	WriteByte(MSG_MULTICAST, event);
};

void(vector vec) MulticastVector =
{
	WriteCoord(MSG_MULTICAST, vec_x);
	WriteCoord(MSG_MULTICAST, vec_y);
	WriteCoord(MSG_MULTICAST, vec_z);
};

void(float val) MulticastByte =
{
	WriteByte(MSG_MULTICAST, val);
};

void(float val) MulticastShort =
{
	WriteShort(MSG_MULTICAST, val);
};

void(float val) MulticastFloat =
{
	WriteFloat(MSG_MULTICAST, val);
};

void(entity e) MulticastEnt =
{
	WriteEntity(MSG_MULTICAST, e);
};

void(string s) MulticastString =
{
	WriteString(MSG_MULTICAST, s);
};

void() light =
{
	remove(self);
};

entity player_chain_head;
.entity player_chain_next;
.entity player_chain_prev;

// Put an entity as the first of the linked list
void(entity adding) player_chain_add =
{
	if (adding.player_chain_prev || adding.player_chain_next || (adding == player_chain_head && !adding.player_chain_next)) 
	{
		print("Trying to adding an entity into player chain while it already is in chain!\n");
		return;
	}
	if (player_chain_head) player_chain_head.player_chain_prev = adding;
	adding.player_chain_next = player_chain_head;
	player_chain_head = adding;
};

// Remove entity from linked list
void(entity removing) player_chain_remove =
{
	if (removing == player_chain_head)
	{
		player_chain_head = removing.player_chain_next;
	}
	
	if (removing.player_chain_next) removing.player_chain_next.player_chain_prev = removing.player_chain_prev;
	if (removing.player_chain_prev) removing.player_chain_prev.player_chain_next = removing.player_chain_next;
	removing.player_chain_next = world;
	removing.player_chain_prev = world;
};

//Halo defs
.float respawntime;
.int *runtime_current;
.int *runtime_minimum;
.int *runtime_maximum;
float DONT_PLACE_AT_START = 1;
float GAMETYPE_SPECIFIC = 2;
float INHIBIT_RESPAWN = 4;
float SPAWNED_ACTIVE = 8;

.entity primary;
.entity secondary;
.entity active_weapon;
//AI defs
.vector lastseen; //where the prop was last perceived.
.float scary; //last scary factor.
// I paid for the whole float.
float ACT_NONE = 0;
float ACT_SLEEP = 2;
float ACT_FIGHT = 4;
float ACT_FLEE = 8;
float ACT_UNCOVER = 16;
float ACT_GUARD = 32;
float ACT_SEARCH = 64;
float ACT_WAIT = 128;
float ACT_VEHICLE = 256;
float ACT_CHARGE = 512;
float ACT_OBEY = 1024;
float ACT_CONVERSE = 2048;
float ACT_AVOID = 4096;
float STA_NONE = 0;
float STA_IDLE = 8192;
float STA_ACTIVE = 16384;
float STA_COMBAT = 32768;
float STA_SEARCHING = 65536;
float STA_UNCERTAIN = 131072;
float STA_CERTAIN = 262144;
float STA_SIGHT = 524288;
float STA_NEAR = 1048576;
float STA_KRIEG = 2097152;

float UNLIMITED_AMMO;
float BOTTOMLESS_CLIP;

typedef struct
{
  int runtime_current;
  int runtime_minimum;
  int runtime_maximum; //ignore 0
} runtime_t;

#define RUNTIME(class_runtime)\
	runtime_current = &class_runtime.runtime_current;\
	class_runtime.runtime_current += 1;\
	runtime_minimum = &class_runtime.runtime_minimum;\
	runtime_maximum = &class_runtime.runtime_maximum;\
	dprint(#class_runtime "runtime current");\
	dprint(ftos(*this.runtime_current));\
	dprint("\n")
  /*
typedef struct
{
	string title;
	string description;
	float mode;
	float rules; //flags
	void basictraits;
} game_type;
.game_type currentgametype;
*/
//useful defs
.float() attack; //returns TRUE or FALSE
#define gamemodels "mdls/"
.void() equip;
.void() weapon_use;
.void() drops;

//Quake defs
.void(entity inflictor, float damage) th_pain;
.void() th_stand;
.void() th_walk;
.void() th_run;
.void() th_die;
.void() th_charge;
//other behaviors
.void() th_shoot;
.void() th_melee;
.void() th_bark;
.void() th_reload;
.void() th_aggro;
.void() th_evade;
.void() th_grenade;
.void() th_board;
.void() th_unboard;
.void() th_crouch;
.void() th_shield;
.void() th_jump;
.void() th_drive;
.void() th_turret;
//.void() th_staggar;
.void() th_uncover;
.void() th_avoid;
.void() th_sleep;
.void() th_alert;
.void() th_flee;
.void() th_converse;
