import Foundation

struct Item: Codable, Identifiable {
    let id: Int
    let name: String
    let profilePictureURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePictureURL = "profile_picture_url"
    }
}
