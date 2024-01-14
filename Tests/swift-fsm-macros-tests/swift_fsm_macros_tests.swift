import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import swift_fsm_macros_event

let testMacros: [String: Macro.Type] = [
    "event": EventMacro.self,
    "eventWithValue": EventWithValueMacro.self
]

final class swift_fsm_macros_tests: XCTestCase {
    func testEventMacro() throws {
        assertMacroExpansion(
            """
            #event(eventName)
            """,
            expandedSource: """
            let eventName = event("eventName")
            """,
            macros: testMacros
        )
    }

    func testEventWithValueMacro() throws {
        assertMacroExpansion(
            """
            #eventWithValue(eventName)
            """,
            expandedSource: """
            let eventName = eventWithValue("eventName")
            """,
            macros: testMacros
        )
    }
}
