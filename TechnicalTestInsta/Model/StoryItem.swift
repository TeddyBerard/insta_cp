//
//  StoryItem.swift
//  TechnicalTestInsta
//
//  Created by Teddy Bérard on 16/04/2025.
//

import Foundation
import SwiftData

struct StoryURL: Codable {
    let url: String
}

@Model
final class StoryItem {
    var id: Int
    var name: String
    var profilePictureURL: String
    var pictureURLs: [StoryURL]
    var hasUnseenStory: Bool
    var watchedIndex: Int
    var likedIndexPictures: [Int]
    
    init(id: Int, name: String, profilePictureURL: String, pictureURLs: [StoryURL], hasUnseenStory: Bool = true) {
        self.id = id
        self.name = name
        self.profilePictureURL = profilePictureURL
        self.pictureURLs = pictureURLs
        self.hasUnseenStory = hasUnseenStory
        self.watchedIndex = 0
        self.likedIndexPictures = []
    }
    
    func isEqual(_ object: Any?) -> Bool {
        guard let otherStory = object as? StoryItem else { return false }
        return self.id == otherStory.id
    }
}
