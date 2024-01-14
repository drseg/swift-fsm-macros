import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension ExprSyntax {
    func formatted(functionName: String) -> ExprSyntax {
        "static let \(self) = \(raw: functionName)(\"\(self)\")"
    }
}

extension FreestandingMacroExpansionSyntax {
    var expressions: [ExprSyntax] {
        argumentList.map(\.expression)
    }

    var firstExpression: ExprSyntax {
        guard let argument = expressions.first else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return argument
    }
}

public struct EventMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        node.firstExpression.formatted(functionName: "event")
    }
}

public struct EventWithValueMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        node.firstExpression.formatted(functionName: "eventWithValue")
    }
}

public struct EventsMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        ExprSyntax(
            stringLiteral: node.expressions.reduce(into: [ExprSyntax]()) {
                $0.append($1.formatted(functionName: "event"))
            }
                .map(String.init)
                .joined(separator: "\n")
        )
    }
}

@main
struct swift_fsm_macrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EventMacro.self, EventWithValueMacro.self
    ]
}
