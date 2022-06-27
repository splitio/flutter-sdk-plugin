import Foundation

enum Method : String {
    case initialize = "init"
    case client = "getClient"
    case destroy = "destroy"
    case clientReady = "clientReady"
}

enum Argument : String {
    case apiKey = "apiKey"
    case matchingKey = "matchingKey"
    case bucketingKey = "bucketingKey"
    case config = "config"
    case waitForReady = "waitForReady"
}
