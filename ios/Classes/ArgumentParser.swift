import Foundation

protocol ArgumentParser {
    
    func getStringArgument(argumentName: String, arguments: Any?) -> String?
    
    func getBooleanArgument(argumentName: String, arguments: Any?) -> Bool
    
    func getMapArgument(argumentName: String, arguments: Any?) -> [String: Any?]
}

class DefaultArgumentParser : ArgumentParser {
    
    func getStringArgument(argumentName: String, arguments: Any?) -> String? {
        guard let arguments = arguments as? [String: Any?] else {
            return nil
        }
        
        guard let argumentValue = arguments[argumentName] as? String? else {
            return nil
        }
        
        return argumentValue
    }
    
    func getBooleanArgument(argumentName: String, arguments: Any?) -> Bool {
        guard let arguments = arguments as? [String: Any?] else {
            return false
        }
        
        guard let argumentValue = arguments[argumentName] as? Bool else {
            return false
        }
        
        return argumentValue
    }
    
    func getMapArgument(argumentName: String, arguments: Any?) -> [String: Any?] {
        guard let arguments = arguments as? [String: Any?] else {
            return [:]
        }
        
        guard let argumentValue = arguments[argumentName] as? [String: Any?] else {
            return [:]
        }
        
        return argumentValue
    }
}
