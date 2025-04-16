//
//  StoryViewModel.swift
//  TechnicalTestInsta
//
//  Created by Teddy Bérard on 16/04/2025.
//

import Foundation
import SwiftData
import SwiftUI

struct Page: Codable {
    let users: [Item]
}

struct UsersResponse: Codable {
    let pages: [Page]
}

class StoryViewModel: ObservableObject {
    @Published var stories: [StoryItem] = []
    @Published public var selectedStory: StoryItem?
    @Published public var showStoryModal = false
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext = ModelContext(try! ModelContainer(for: StoryItem.self))) {
        self.modelContext = modelContext
        loadStoriesFromLocal()
    }
    
    private func generateRandomPictureURLs() -> [StoryURL] {
        let count = Int.random(in: 1...5)
        return (0..<count).map { _ in
            return StoryURL(url: "https://picsum.photos/id/\(Int.random(in: 1...500))/800/1200")
        }
    }
    
    private func loadStoriesFromLocal() {
        guard let url = Bundle.main.url(forResource: "users", withExtension: "json") else {
            print("Error: Cannot find users.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(UsersResponse.self, from: data)
            
            let newStories = response.pages.flatMap {
                $0.users.map { user in
                    let story = StoryItem(
                        id: user.id,
                        name: user.name,
                        profilePictureURL: user.profilePictureURL,
                        pictureURLs: generateRandomPictureURLs()
                    )
                    modelContext.insert(story)
                    return story
                }
            }
            
            self.stories = newStories
        } catch {
            print("Error loading stories: \(error)")
        }
    }
    
    public func showStory(_ story: StoryItem) {
        selectedStory = story
        showStoryModal = true
    }
}
