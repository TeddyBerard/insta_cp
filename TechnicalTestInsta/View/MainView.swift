//
//  ContentView.swift
//  TechnicalTestInsta
//
//  Created by Teddy Bérard on 16/04/2025.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var storyViewModel = StoryViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(storyViewModel.stories) { story in
                        StoryView(story: story)
                            .onTapGesture {
                                storyViewModel.showStory(story)
                            }
                    }
                }
                .frame(height: 90)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .background(Color(.systemBackground))
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray.opacity(0.3)),
                alignment: .bottom
            )
            
            Spacer()
        }
        .fullScreenCover(isPresented: $storyViewModel.showStoryModal) {
            if let story = storyViewModel.selectedStory,
               let index = storyViewModel.stories.firstIndex(where: { $0.id == story.id }) {
                StoryModalView(
                    stories: Array(storyViewModel.stories[index...]),
                    selectedStory: story,
                    initialIndex: 0,
                    isPresented: $storyViewModel.showStoryModal
                )
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: StoryItem.self, inMemory: true)
}
