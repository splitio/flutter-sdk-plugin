import Foundation

enum Method: String {
    case initialize = "init"
    case client = "getClient"
    case destroy = "destroy"
    case clientReady = "clientReady"
    case getTreatment = "getTreatment"
    case getTreatments = "getTreatments"
    case getTreatmentWithConfig = "getTreatmentWithConfig"
    case getTreatmentsWithConfig = "getTreatmentsWithConfig"
    case track = "track"
}

enum Argument: String {
    case apiKey = "apiKey"
    case matchingKey = "matchingKey"
    case bucketingKey = "bucketingKey"
    case config = "config"
    case waitForReady = "waitForReady"
    case splitName = "splitName"
    case attributes = "attributes"
    case eventType = "eventType"
    case trafficType = "trafficType"
    case value = "value"
    case properties = "properties"
}
