import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import swift_fsm_macros_event

let testMacros: [String: Macro.Type] = [
    "event": EventMacro.self,
    "events": EventsMacro.self,
    "eventWithValue": EventWithValueMacro.self,
    "eventsWithValue": EventsWithValueMacro.self
]

final class swift_fsm_macros_tests: XCTestCase {
    func testEventMacro() throws {
        assertMacroExpansion(
            """
            #event("eventName")
            """,
            expandedSource: """
            static let eventName = event("eventName")
            """,
            macros: testMacros
        )
    }

    func testEventWithValueMacro() throws {
        assertMacroExpansion(
            """
            #eventWithValue("eventName")
            """,
            expandedSource: """
            static let eventName = eventWithValue("eventName")
            """,
            macros: testMacros
        )
    }

    func testEventsMacro() throws {
        assertMacroExpansion(
            """
            #events("first", "second", "third", "fourth")
            """,
            expandedSource: """
            static let first = event("first")
            static let second = event("second")
            static let third = event("third")
            static let fourth = event("fourth")
            """,
            macros: testMacros
        )
    }

    func testEventsWithValueMacro() throws {
        assertMacroExpansion(
            """
            #eventsWithValue("first", "second", "third", "fourth")
            """,
            expandedSource: """
            static let first = eventWithValue("first")
            static let second = eventWithValue("second")
            static let third = eventWithValue("third")
            static let fourth = eventWithValue("fourth")
            """,
            macros: testMacros
        )
    }
}
