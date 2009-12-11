/* vim: set ts=8 et sw=4 sta ai cin: */
#ifndef __LUASOFIA_UTILS_H__
#define __LUASOFIA_UTILS_H__

typedef struct luasofia_reg_const_s {
  const char *name;
  int value;
} luasofia_reg_const_t;

void luasofia_const_register_constants(lua_State *L, const luasofia_reg_const_t *consts);

#endif //__LUASOFIA_UTILS
