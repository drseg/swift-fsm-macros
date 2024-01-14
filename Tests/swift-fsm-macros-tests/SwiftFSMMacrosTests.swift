import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import swift_fsm_macros_event
import swift_fsm_macros

let testMacros: [String: Macro.Type] = [
    "event": EventMacro.self,
    "eventWithValue": EventWithValueMacro.self,
]

final class swift_fsm_macros_tests: XCTestCase {
    #event("cat", "fish")
    #eventWithValue("dog", "llama")

    static func event(_ s: String) -> String { s }
    static func eventWithValue(_ s: String) -> String { s }

    func testEventMacroExpansion() throws {
        assertMacroExpansion(
            """
            #event("first", "second", "third", "fourth")
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

    func testEventMacro() throws {
        XCTAssertEqual(Self.cat, "cat")
        XCTAssertEqual(Self.fish, "fish")
    }

    func testEventWithValueMacroExpansion() throws {
        assertMacroExpansion(
            """
            #eventWithValue("first", "second", "third", "fourth")
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

    func testEventWithValueMacro() throws {
        XCTAssertEqual(Self.dog, "dog")
        XCTAssertEqual(Self.llama, "llama")
    }
}
