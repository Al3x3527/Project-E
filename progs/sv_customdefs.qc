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

enumflags int //have to be flags for control
{
	ACT_NONE = 0,
		ACT_SLEEP,
		ACT_FIGHT,
		ACT_FLEE,
		ACT_UNCOVER,
		ACT_GUARD,
		ACT_SEARCH,
		ACT_WAIT,
		ACT_VEHICLE,
		ACT_CHARGE,
		ACT_OBEY,
		ACT_CONVERSE,
		ACT_AVOID
};

enumflags int
{
	STA_NONE,
		STA_IDLE,
		STA_ACTIVE,
		STA_COMBAT,
		STA_SEARCHING,
		STA_UNCERTAIN,
		STA_CERTAIN,
		STA_SIGHT,
		STA_NEAR,
		STA_KRIEG
};

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
	runtime_maximum = &class_runtime.runtime_maximum
	//dprint(#class_runtime "runtime current");\
	//dprint(ftos(*this.runtime_current));\
	//dprint("\n")
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
entity searchent;
float searchtime;
.entity searchchain;
//entity searchhead;
.float() attack; //returns TRUE or FALSE
#define gamemodels "mdls/"
.void() equip;
.void() weapon_use;
.void() drops;
.float wait;

void() sub_chainmoved = {
	entity parent = self.owner;
	self.angles = parent.angles + self.v_angle;
	self.avelocity = parent.avelocity;
	setorigin(self, self.origin + parent.view_ofs - self.view_ofs);
};

void() sub_changeyaw = {
	float ang = self.ideal_yaw;
	vector angle = '0 0 0';
	angle_z = ang;
	float avel = self.yaw_speed;
	entity parent = self;
	ChangeYaw();
	self = self.movechain;
	self.yaw_speed = avel * 2;
	self.ideal_yaw = ang;
	ChangeYaw();
	v_forward = parent.view_ofs - self.view_ofs;
	rotatevectorsbyangle(angle);
	setorigin(self, parent.origin + v_forward);
	self = parent;
};

const float FL_SEARCHPOINT = 4096;
const float FL_COVER = 8192;
const float FL_VEHICLE = 32768;
//make enumflags class squadstyle or macros
//pick one
const float FL_NOSQUAD = 1;
const float FL_UNASSIGNED = 2;
const float FL_ASSIGNED = 4;
//pick one
const float MAN_GRUNT = 8;
const float MAN_HEAVY = 16;
const float MAN_ELITE = 32;
const float PAN_GRUNT = 64;
const float PAN_HEAVY = 128;
const float PAN_ELITE = 256;
const float DRA_GRUNT = 512;
const float DRA_HEAVY = 1024;
const float DRA_ELITE = 2048;
const float FRO_GRUNT = 4096;
const float FRO_HEAVY = 8192;
const float FRO_ELITE;
const float WIG_ULTRA;
const float FPV_GRUNT;
const float FPV_HEAVY;
const float FPV_ELITE;
const float FPV_ULTRA;
const float MAN_PILOT;
const float PAN_PILOT;
const float DRA_PILOT;
const float FRO_PILOT;
const float ZOM_GRUNT;
const float ZOM_HEAVY;
const float ZOM_ELITE;
const float ZOM_ULTRA;
const float SEN_GRUNT;
const float SEN_HEAVY;
const float SEN_ELITE = 2^30;
//squad styles
const float PAN_LIGHT = PAN_GRUNT + FRO_GRUNT + FRO_HEAVY;

const float TEAM_NATO = 2;
const float TEAM_NAZI = 4;
const float TEAM_HYPE = 8;
const float TEAM_ARMY = 16;
const float TEAM_LIST = 32;
const float TEAM_HELL = 64;

const int DIST_KREIG = 1;
const int DIST_NEAR = 2;
const int DIST_MED = 3;
const int DIST_FAR = 4;

const int SEARCH_SOUND = 1;
const int SEARCH_SEEN = 2;
const int SEARCH_SCRIPTED = 3;

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
.void() th_fooled;
//separate behaviors from animations
.void() th_wait; //ready for combat, may be defending
.void() th_guard;
.void() th_search;
.void() th_cover; //what to do behind cover
