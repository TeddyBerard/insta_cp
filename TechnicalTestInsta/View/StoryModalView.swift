import SwiftUI
import Kingfisher

struct StoryModalView: View {
    let stories: [StoryItem]
    @Binding var isPresented: Bool
    @StateObject private var viewModel: StoryModalViewModel
    @Namespace private var animation
    
    init(
        stories: [StoryItem],
        selectedStory: StoryItem,
        initialIndex: Int = 0,
        isPresented: Binding<Bool>
    ) {
        self.stories = stories
        self._isPresented = isPresented
        self._viewModel = StateObject(
            wrappedValue: StoryModalViewModel(
                isPresented: isPresented,
                currentStory: selectedStory,
                stories: stories,
                initialIndex: initialIndex
            )
        )
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ZStack {
                if viewModel.isImageLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                
                VStack {
                    KFImage(URL(string: viewModel.currentImageURL)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                }
                
                if !viewModel.isLongPressed {
                    VStack(spacing: 8) {
                        HStack(spacing: 4) {
                            ForEach(0..<$viewModel.currentStory.pictureURLs.count, id: \.self) { index in
                                ProgressBar(
                                    progress: index == viewModel.currentStory.watchedIndex ? viewModel.progress : (index < viewModel.currentStory.watchedIndex ? 1 : 0)
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        HStack {
                            KFImage(URL(string: viewModel.currentStory.profilePictureURL))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            
                            Text(viewModel.currentStory.name)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button {
                                viewModel.stopProgress()
                                isPresented = false
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold))
                            }
                        }
                        .padding()
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            TextField("Send message", text: .constant(""))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .foregroundColor(.white)
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "heart")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                            }
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "paperplane")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                }
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            viewModel.moveToPreviousStoryImage()
                        }
                    
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    viewModel.isLongPressed = true
                                    viewModel.pauseProgress()
                                }
                                .onEnded { _ in
                                    viewModel.isLongPressed = false
                                    viewModel.resumeProgress()
                                }
                        )
                    
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            viewModel.moveToNextStoryImage()
                        }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .statusBar(hidden: true)
        .onAppear {
            viewModel.startProgress()
        }
        .onDisappear {
            viewModel.stopProgress()
        }
    }
}

private struct ProgressBar: View {
    let progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.white.opacity(0.3))
                
                Rectangle()
                    .fill(.white)
                    .frame(width: geometry.size.width * progress)
                    .animation(.linear(duration: 0.1), value: progress)
            }
        }
        .frame(height: 2)
    }
}
