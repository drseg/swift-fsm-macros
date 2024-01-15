import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import swift_fsm_macros_event
import swift_fsm_macros

let testMacros: [String: Macro.Type] = [
    "events": EventMacro.self,
    "eventsWithValue": EventWithValueMacro.self,
]

final class SwiftFSMMacrosTests: XCTestCase {
    #event("robin")
    #events("cat", "fish")

    #eventWithValue("jay")
    #eventsWithValue("dog", "llama")

    static func event(_ s: String) -> String { s }
    static func eventWithValue(_ s: String) -> String { s }

    func testEventMacroExpansion() throws {
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

    func testEventMacro() throws {
        XCTAssertEqual(SwiftFSMMacrosTests.cat, "cat")
        XCTAssertEqual(SwiftFSMMacrosTests.fish, "fish")
    }

    func testEventWithValueMacroExpansion() throws {
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

    func testEventWithValueMacro() throws {
        XCTAssertEqual(SwiftFSMMacrosTests.dog, "dog")
        XCTAssertEqual(SwiftFSMMacrosTests.llama, "llama")
    }

    func testSingularMacros() throws {
        XCTAssertEqual(SwiftFSMMacrosTests.robin, "robin")
        XCTAssertEqual(SwiftFSMMacrosTests.jay, "jay")
    }
}
