# External Libraries:

I chose Kingfisher because it is a fast, and reliable Swift framework for loading images. It offers:
- A simple and easy-to-integrate API
- Built-in caching (memory + disk)
- Optimized performance and asynchronous loading
- Support for both UIKit and SwiftUI
- Advanced features like placeholders, retry logic, and image transformations
- It’s a solid choice that avoids reinventing the wheel while ensuring a great user experience. 

## Technical Implementation Overview

### 1. MVVM Architecture  
I structured the project following the **MVVM pattern**, which ensures a clear separation of concerns:

- **Views**: `StoryModalView`, `StoryView`
- **ViewModel**: `StoryModalViewModel`
- **Model**: `StoryItem`

This architecture improves readability, testability, and maintainability of the codebase.

---

### 2. State Management  
I used SwiftUI’s reactive features to manage state efficiently:

- `@StateObject` to initialize and manage the ViewModel lifecycle
- `@Published` properties to trigger UI updates
- `Binding` for two-way communication between views and the ViewModel

---

### 3. Reusable Components  
To keep the code modular and clean, I extracted the `ProgressBar` into a separate reusable component. Views are structured in a way that promotes reusability and scalability across the app.

---

### 4. Image Loading with Kingfisher  
For asynchronous image loading, I integrated **Kingfisher**, a lightweight and powerful library that:

- Supports remote image downloading and caching (memory + disk)
- Offers better performance and smoother UI experiences
- Simplifies image handling with a concise and SwiftUI-compatible API

---

### 5. Timer Management for Story Progression  
I implemented a timer system in the ViewModel to manage story progression. It includes controls for:

- Pause
- Resume
- Stop

This logic is encapsulated cleanly to maintain separation from the UI.

---

### 6. User Interactions  
User gestures are handled thoughtfully to ensure a smooth experience:

- **Tap** and **Long Press** gestures are well integrated
- Touch areas are clearly defined to avoid gesture conflicts

---

