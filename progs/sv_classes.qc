#define FOOBAR "mdls/w_AD70.mdl"
class foo : entity
{
  virtual void() foothink ={
    setmodel(this,FOOBAR);
  };
  void() foo = {
    precache_model(FOOBAR);
    think = foothink;
    nextthink = time + 0.3;
  };
};
class bar : entity {
void() bar = {
foo myfoo = spawn(foo);
  myfoo.foothink();
};
};
