import Split

extension Impression {
    func toMap() -> [String: Any?] {
        ["key": keyName,
         "bucketingKey": bucketingKey,
         "split": feature,
         "treatment": treatment,
         "time": time,
         "appliedRule": label,
         "changeNumber": changeNumber,
         "attributes": attributes]
    }
}

extension SplitView {
    static func asMap(splitView: SplitView?) -> [String: Any?] {
        if let splitView = splitView {
            return [
                "name": splitView.name,
                "trafficType": splitView.trafficType,
                "killed": splitView.killed,
                "treatments": splitView.treatments,
                "changeNumber": splitView.changeNumber,
                "configs": splitView.configs]
        } else {
            return [:]
        }
    }
}
