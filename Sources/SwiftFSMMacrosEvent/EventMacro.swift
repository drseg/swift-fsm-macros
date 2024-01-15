import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct EventMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext)
    throws -> [SwiftSyntax.DeclSyntax] {
        try node.eventsFormatted(functionName: "event")
    }
}

public struct EventWithValueMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        try node.eventsFormatted(functionName: "eventWithValue")
    }
}

extension ExprSyntax {
    func formatted(functionName: String) throws -> DeclSyntax {
        guard
            let segments = self.as(StringLiteralExprSyntax.self)?.segments,
            case .stringSegment(let literalSegment)? = segments.first else {
            throw "Event names must be String literals"
        }

        let text = literalSegment.content.text
        return "static let \(raw: text) = \(raw: functionName)(\"\(raw: text)\")"
    }
}

extension FreestandingMacroExpansionSyntax {
    func eventsFormatted(functionName: String) throws -> [DeclSyntax] {
        try argumentList.map(\.expression).reduce(into: [DeclSyntax]()) {
            $0.append(try $1.formatted(functionName: functionName))
        }
    }
}

extension String: Error { }

@main
struct SwiftFSMMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EventMacro.self, EventWithValueMacro.self
    ]
}
