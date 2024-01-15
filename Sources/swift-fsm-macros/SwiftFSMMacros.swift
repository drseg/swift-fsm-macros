@freestanding(declaration, names: arbitrary)
public macro event(_ named: String) = #externalMacro(module: "swift_fsm_macros_event",
                                                     type: "EventMacro")
@freestanding(declaration, names: arbitrary)
public macro events(_ named: String...) = #externalMacro(module: "swift_fsm_macros_event",
                                                         type: "EventMacro")
@freestanding(declaration, names: arbitrary)
public macro eventWithValue(_ named: String) = #externalMacro(module: "swift_fsm_macros_event",
                                                              type: "EventWithValueMacro")
@freestanding(declaration, names: arbitrary)
public macro eventsWithValue(_ named: String...) = #externalMacro(module: "swift_fsm_macros_event",
                                                                  type: "EventWithValueMacro")
