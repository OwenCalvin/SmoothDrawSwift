import Foundation

class SessionInstance {
    var Username: String?
    var SessionID: String?
    var SessionUsers: [(String, String)]?
    var connected: Bool = false
    
    init() {}
    init(username: String) {
        Username = username
    }
}
