TARGET = luasofia.so

OBJECTS = luasofia.o \
	  luasofia_weak_table.o \
	  luasofia_tags.o \
	  luasofia_const.o \
	  luasofia_proxy.o \
          luasofia_su.o \
	  luasofia_su_root.o \
	  luasofia_su_timer.o \
	  luasofia_su_task.o \
	  luasofia_su_tags.o \
	  luasofia_nua.o \
	  luasofia_sip.o \
	  luasofia_soa.o \
	  luasofia_url.o \
	  luasofia_sdp.o \
	  luasofia_utils.o \
	  luasofia_sdp_parser.o

CFLAGS += -O2 -c -Wall -fPIC -I./src
CFLAGS += `pkg-config --cflags sofia-sip-ua lua5.1`

LDFLAGS += `pkg-config --libs sofia-sip-ua lua5.1`

DIR_OBJS = $(addprefix .objs/, $(OBJECTS))

all: mkobjs $(TARGET)

mkobjs:
	@mkdir -p .objs

.objs/%.o : src/%.c
	$(CC) $(CFLAGS) -o $@ $<
       
.objs/%.o : src/sip/%.c
	$(CC) $(CFLAGS) -o $@ $<

.objs/%.o : src/url/%.c
	$(CC) $(CFLAGS) -o $@ $<

.objs/%.o : src/soa/%.c
	$(CC) $(CFLAGS) -o $@ $<

.objs/%.o : src/nua/%.c
	$(CC) $(CFLAGS) -o $@ $<

.objs/%.o : src/sdp/%.c
	$(CC) $(CFLAGS) -o $@ $<

.objs/%.o : src/su/%.c
	$(CC) $(CFLAGS) -o $@ $<

.objs/%.o : src/utils/%.c
	$(CC) $(CFLAGS) -o $@ $<

$(TARGET) : $(DIR_OBJS)
	$(CC) -shared -o $@ $(DIR_OBJS) $(LDFLAGS)

check: all check_su check_nua

check_su:
	lua test/su.lua

check_nua:
	lua test/nua.lua

clean:
	@rm -rf .objs *.so *~ *.out core $(TARGET)

