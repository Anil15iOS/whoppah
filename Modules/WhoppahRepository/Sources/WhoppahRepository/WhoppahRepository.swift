public struct WhoppahRepository {
    
    public enum Error: Swift.Error {
        case notImplemented
        case noData
        case missingParameter(named: String)
        case missingUser
        case missingAuction
    }
    
    public init() {
    }
}
