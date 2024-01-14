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
    var firstArgument: ExprSyntax {
        guard let argument = argumentList.first?.expression else {
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
        node.firstArgument.formatted(functionName: "event")
    }
}

public struct EventWithValueMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        node.firstArgument.formatted(functionName: "eventWithValue")
    }
}

@main
struct swift_fsm_macrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EventMacro.self, EventWithValueMacro.self
    ]
}
