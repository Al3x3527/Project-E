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
//float gametype; //entity game type
.entity primary;
.entity secondary;


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
	dprint("#class_runtime runtime current");\
	dprint(ftos(*this.runtime_current));\
	dprint("\n");
  /*
typedef struct
{
	string title;
	string description;
	float mode;
	float rules; //flags
	void player_traits();
} game_type;
.game_type currentgametype;
*/
//useful defs
.float(float times) attack; //returns TRUE or FALSE
#define gamemodels "mdls/"
.void() equip;
.void() weapon_use;

/*
float GT_SHOW_CLOCK = 1;
class parms_test : entity {
	void() parms_test = {
		//test_mode parms
	};
};
void() test_traits = {parms_test foo = spawn(parms_test);};
game_type test_mode = {
	"test mode",
	"for testing",
	TEST_MODE = 1,
	GT_SHOW_CLOCK,
	test_traits
}; */
