import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct EventMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext)
    throws -> [SwiftSyntax.DeclSyntax] {
        [try node.eventsFormatted(functionName: "event")]
    }
}

public struct EventWithValueMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        [try node.eventsFormatted(functionName: "eventWithValue")]
    }
}

extension ExprSyntax {
    func formatted(functionName: String) throws -> DeclSyntax {
        guard
            let literalSegs = self.as(StringLiteralExprSyntax.self)?.segments,
            case .stringSegment(let literalSegment)? = literalSegs.first else {
            throw "Event names must be String literals"
        }

        let text = literalSegment.content.text
        return "static let \(raw: text) = \(raw: functionName)(\"\(raw: text)\")"
    }
}

extension FreestandingMacroExpansionSyntax {
    var expressions: [ExprSyntax] {
        argumentList.map(\.expression)
    }

    func eventsFormatted(functionName: String) throws -> DeclSyntax {
        DeclSyntax(
            stringLiteral: try expressions.reduce(into: [DeclSyntax]()) {
                $0.append(try $1.formatted(functionName: functionName))
            }
                .map(String.init)
                .joined(separator: "\n")
        )
    }
}

extension String: Error { }

@main
struct swift_fsm_macrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EventMacro.self, EventWithValueMacro.self
    ]
}