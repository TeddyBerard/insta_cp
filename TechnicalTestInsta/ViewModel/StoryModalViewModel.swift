import Foundation
import SwiftUI
import Combine
import Kingfisher

class StoryModalViewModel: ObservableObject {
    @Published var progress: CGFloat = 0
    @Published var currentStoryIndex: Int = 0
    @Published var currentStory: StoryItem
    @Published var currentImageURL: String
    @Published var isImageLoading: Bool = true
    @Published var isLongPressed: Bool = false

    private var timer: Timer?
    private var isPresented: Binding<Bool>
    private var isPaused: Bool = false
    private let stories: [StoryItem]
    private let storyDuration: TimeInterval = 5.0
    
    init(
        isPresented: Binding<Bool>,
        currentStory: StoryItem,
        stories: [StoryItem],
        initialIndex: Int = 0
    ) {
        self.isPresented = isPresented
        self.stories = stories
        self.currentStory = currentStory
        self.currentStoryIndex = stories.firstIndex(of: currentStory) ?? 0
        self.currentImageURL = currentStory.pictureURLs[currentStory.watchedIndex].url
        loadCurrentImage()
        prefetchImages()
    }
    
    private func prefetchImages() {
        let urls = currentStory.pictureURLs.map { URL(string: $0.url) }.compactMap { $0 }
        ImagePrefetcher(urls: urls).start()
    }
    
    private func loadCurrentImage() {
        isImageLoading = true
        guard let url = URL(string: currentImageURL) else { return }
        
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            guard let self = self else { return }
            
            Task { @MainActor in
                self.isImageLoading = false
                switch result {
                case .success(_):
                    self.startProgress()
                case .failure(_):
                    self.moveToNextStoryImage()
                }
            }
        }
    }
    
    func startProgress() {
        guard !isImageLoading else { return }
        
        timer?.invalidate()
        
        if !isPaused {
            withAnimation(.linear(duration: 0.2)) {
                progress = 0
            }
        }
        
        isPaused = false
        
        let interval = 0.01
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self, !self.isPaused else { return }
            
            withAnimation(.linear(duration: interval)) {
                if self.progress < 1.0 {
                    self.progress += CGFloat(interval / self.storyDuration)
                } else {
                    self.moveToNextStoryImage()
                }
            }
        }
    }
    
    func pauseProgress() {
        isPaused = true
        timer?.invalidate()
    }
    
    func resumeProgress() {
        if isPaused {
            startProgress()
        }
    }
    
    func stopProgress() {
        isPaused = false
        timer?.invalidate()
    }
    
    func moveToNextStoryImage() {
        timer?.invalidate()
        
        withAnimation(.linear(duration: 0.2)) {
            if currentStoryIndex < stories.count - 1 {
                if currentStory.watchedIndex < currentStory.pictureURLs.count - 1 {
                    currentStory.watchedIndex += 1
                    progress = 0
                } else {
                    progress = 0
                    currentStory.hasUnseenStory = false
                    currentStoryIndex += 1
                    currentStory = stories[currentStoryIndex]
                    prefetchImages()
                }
                
                self.currentImageURL = currentStory.pictureURLs[currentStory.watchedIndex].url
                loadCurrentImage()
            } else {
                stopProgress()
                isPresented.wrappedValue = false
            }
        }
    }
    
    func moveToPreviousStoryImage() {
        timer?.invalidate()
        
        withAnimation(.linear(duration: 0.2)) {
            if currentStory.watchedIndex > 0 {
                currentStory.watchedIndex -= 1
                progress = 0
            } else if currentStoryIndex > 0 {
                currentStoryIndex -= 1
                currentStory = stories[currentStoryIndex]
                currentStory.watchedIndex = currentStory.pictureURLs.count - 1
                progress = 0
            } else {
                progress = 0
            }
            
            self.currentImageURL = currentStory.pictureURLs[currentStory.watchedIndex].url
            loadCurrentImage()
        }
    }
    
    func isLikedPicture() -> Bool {
        return currentStory.likedIndexPictures.contains(currentStory.watchedIndex)
    }
    
    func likePicture() {
        if currentStory.likedIndexPictures.contains(currentStory.watchedIndex) {
            currentStory.likedIndexPictures.removeAll(where: { $0 == currentStory.watchedIndex })
        } else {
            currentStory.likedIndexPictures.append(currentStory.watchedIndex)
        }
        
    }
    
    deinit {
        timer?.invalidate()
    }
}
