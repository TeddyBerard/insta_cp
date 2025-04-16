import SwiftUI
import Kingfisher

struct StoryView: View {
    let story: StoryItem
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .strokeBorder(
                        story.hasUnseenStory ?
                        LinearGradient(
                            colors: [
                                .blue,
                                .red,
                                .purple
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                            LinearGradient(
                                colors: [.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                        lineWidth: 3
                    )
                    .frame(width: 73, height: 73)
                
                KFImage(URL(string: story.profilePictureURL))
                    .placeholder {
                        Circle()
                            .fill(.gray)
                            .frame(width: 65, height: 65)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
            }
            
            Text(story.name.lowercased())
                .font(.caption)
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}
