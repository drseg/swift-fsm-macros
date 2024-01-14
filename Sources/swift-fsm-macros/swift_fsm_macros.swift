@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "swift_fsm_macrosMacros", type: "StringifyMacro")