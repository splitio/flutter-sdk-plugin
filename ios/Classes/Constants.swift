import Foundation

enum Method: String {
    case initialize = "init"
    case client = "getClient"
    case destroy = "destroy"
    case flush = "flush"
    case clientReady = "clientReady"
    case clientReadyFromCache = "clientReadyFromCache"
    case clientUpdated = "clientUpdated"
    case clientTimeout = "clientTimeout"
    case getTreatment = "getTreatment"
    case getTreatments = "getTreatments"
    case getTreatmentWithConfig = "getTreatmentWithConfig"
    case getTreatmentsWithConfig = "getTreatmentsWithConfig"
    case track = "track"
    case getAttribute = "getAttribute"
    case getAllAttributes = "getAllAttributes"
    case setAttribute = "setAttribute"
    case setAttributes = "setAttributes"
    case removeAttribute = "removeAttribute"
    case clearAttributes = "clearAttributes"
}

enum Argument: String {
    case apiKey = "apiKey"
    case matchingKey = "matchingKey"
    case bucketingKey = "bucketingKey"
    case config = "config"
    case splitName = "splitName"
    case attributes = "attributes"
    case eventType = "eventType"
    case trafficType = "trafficType"
    case value = "value"
    case properties = "properties"
    case attributeName = "attributeName"
}
