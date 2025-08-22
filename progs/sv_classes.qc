#define FOOBAR "mdls/w_AD70.mdl"
#define SPAWNCLASSMODEL(foo) void() foo = {\
    precache_model(FOOBAR);\
    setmodel(this, FOOBAR);
#define ENDCLASS };
class foo : entity {
  SPAWNCLASSMODEL(foo)
  ENDCLASS
};
class bar : foo {};
