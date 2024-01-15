import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SwiftFSMMacros
import SwiftFSMMacrosEvent

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

    func testEventExpansion() throws {
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

    func testEventExpansionOnlyAllowsStringLiterals() throws {
        assertMacroExpansion(
            "#events(first)",
            expandedSource: "#events(first)",
            diagnostics: [.init("Event names must be String literals")],
            macros: testMacros
        )
    }

    func testEventsMacro() throws {
        XCTAssertEqual(Self.cat, "cat")
        XCTAssertEqual(Self.fish, "fish")
    }

    func testEventsWithValueExpansion() throws {
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

    func testEventsWithValueExpansionOnlyAllowsStringLiterals() throws {
        assertMacroExpansion(
            "#eventsWithValue(first)",
            expandedSource: "#eventsWithValue(first)",
            diagnostics: [.init("Event names must be String literals")],
            macros: testMacros
        )
    }

    func testEventsWithValueMacro() throws {
        XCTAssertEqual(Self.dog, "dog")
        XCTAssertEqual(Self.llama, "llama")
    }

    func testSingularMacros() throws {
        XCTAssertEqual(Self.robin, "robin")
        XCTAssertEqual(Self.jay, "jay")
    }
}

extension DiagnosticSpec {
    init(_ message: String) {
        self.init(message: message, line: 1, column: 1)
    }
}
