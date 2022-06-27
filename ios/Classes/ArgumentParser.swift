import Foundation

protocol ArgumentParser {

    func getStringArgument(argumentName: Argument, arguments: Any?) -> String?

    func getBooleanArgument(argumentName: Argument, arguments: Any?) -> Bool

    func getMapArgument(argumentName: Argument, arguments: Any?) -> [String: Any?]

    func getStringListArgument(argumentName: Argument, arguments: Any?) -> [String]
}

class DefaultArgumentParser: ArgumentParser {

    func getStringArgument(argumentName: Argument, arguments: Any?) -> String? {
        guard let arguments = arguments as? [String: Any?] else {
            return nil
        }

        guard let argumentValue = arguments[argumentName.rawValue] as? String? else {
            return nil
        }

        return argumentValue
    }

    func getBooleanArgument(argumentName: Argument, arguments: Any?) -> Bool {
        guard let arguments = arguments as? [String: Any?] else {
            return false
        }

        guard let argumentValue = arguments[argumentName.rawValue] as? Bool else {
            return false
        }

        return argumentValue
    }

    func getMapArgument(argumentName: Argument, arguments: Any?) -> [String: Any?] {
        guard let arguments = arguments as? [String: Any?] else {
            return [:]
        }

        guard let argumentValue = arguments[argumentName.rawValue] as? [String: Any?] else {
            return [:]
        }

        return argumentValue
    }

    func getStringListArgument(argumentName: Argument, arguments: Any?) -> [String] {
        guard let arguments = arguments as? [String: Any?] else {
            return []
        }

        guard let argumentValue = arguments[argumentName.rawValue] as? [String] else {
            return []
        }

        return argumentValue
    }
}
