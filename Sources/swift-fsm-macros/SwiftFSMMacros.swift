@freestanding(declaration, names: arbitrary)
public macro event(_ value: String...) = #externalMacro(module: "swift_fsm_macros_event", type: "EventMacro")

@freestanding(declaration, names: arbitrary)
public macro eventWithValue(_ value: String...) = #externalMacro(module: "swift_fsm_macros_event", type: "EventWithValueMacro")
