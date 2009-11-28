require "luasofia"

su.init()

root = su.root_create()

callbacks = {}

callbacks["event_handler"] = function (n, event, status, phrase, tags)
                                 print("event_handler: " .. event .. " status: " ..
                                        status .. " phrase: " .. phrase)
                                 if (#tags > 0) then
                                     print("\ttags size[" .. #tags .. "]:")
                                     for i=1, #tags do
                                         print("\t\t" .. tags[i])
                                     end
                                 end
                             end

callbacks[nua.nua_r_set_params] = function (n, event, status, phrase, tags)
                                      print("nua_r_set_params: status[" .. status ..
                                            "] phrase[" .. phrase .. "]")
                                  end

callbacks[nua.nua_r_shutdown] = function (n, event, status, phrase, tags)
                                    print("nua_r_shutdown: status[" .. status ..
                                          "] phrase[" .. phrase .. "]")
                                    root:quit()
                                end

n = nua.create(root, callbacks,
               { NUTAG_URL = "sip:*:5060;transport=udp",
                 NUTAG_USER_AGENT = "lua_test",
                 NUTAG_MEDIA_ENABLE = 1,
                 NUTAG_EARLY_ANSWER = 1,
                 NUTAG_OUTBOUND = "no-validate no-options-keepalive no-natify",
                 NUTAG_M_USERNAME = "1001"
               })

n:set_params({ NUTAG_ENABLEMESSAGE = 1,
               NUTAG_ENABLEINVITE = 1,
               NUTAG_AUTOALERT = 0,
               NUTAG_SESSION_TIMER = 0,
               NUTAG_AUTOANSWER = 0
             })

timer = su.timer_create(root:task(), 200)

timer:set( { timer_handler = function (t)
                 print("timer fired: nua shutdown")
                 n:shutdown()
             end })

root:run()

n = nil
timer = nil
root = nil

su.deinit()

