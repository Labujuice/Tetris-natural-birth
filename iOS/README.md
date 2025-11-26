# How to Build the iOS App

You can build this app on:
1.  **Mac** (using Xcode)
2.  **iPad** (using Swift Playgrounds)

---

## Option 1: Build on Mac (Xcode)

### 1. Create a New Xcode Project
1.  Open Xcode.
2.  Select **Create a new Xcode project**.
3.  Choose **iOS** -> **App**.
4.  Click **Next**.
5.  **Product Name**: `TetrisDIY`.
6.  **Interface**: **Storyboard**.
7.  Click **Next** and save it.

### 2. Import Files
1.  Drag the **contents** of the `iOS` folder (`Models`, `Game`, `ViewControllers`) into your Xcode project navigator.
2.  Check **"Copy items if needed"**.

### 3. Link the View Controller
1.  Open `Main.storyboard`.
2.  Select the View Controller.
3.  Set **Class** to `GameViewController` in the Identity Inspector.
4.  Run the app!

---

## Option 2: Build on iPad (Swift Playgrounds)

### 1. Prepare
1.  Download **Swift Playgrounds** from the App Store (Free).
2.  Open it and tap **App** (at the bottom) to create a new App project.

### 2. Copy Code
You need to copy the code from the files in this repository into your Playground App.

1.  **Create Files**: In the sidebar of your Playground App, create new Swift files to match my structure (or just put them all in one, but separate is better).
    *   `Tetromino.swift`
    *   `Grid.swift`
    *   `GameSettings.swift`
    *   `GameEngine.swift`
    *   `GameScene.swift`
    *   `GameViewController.swift`
    *   `PlaygroundsAdapter.swift`
2.  **Copy Content**: Open each file in this repo, copy the code, and paste it into the corresponding file on your iPad.

### 3. Set Entry Point
1.  Open the main file in your Playground (usually named `MyApp.swift` or similar, it has `@main`).
2.  Replace its content with this:

```swift
import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            // Use the adapter we created in PlaygroundsAdapter.swift
            GameView()
                .ignoresSafeArea()
                .statusBar(hidden: true)
        }
    }
}
```

### 4. Run
Tap the **Play** button on your iPad. The game should start!

---

## Controls
- **Tap**: Rotate
- **Swipe Left/Right**: Move
- **Swipe Down**: Soft Drop
- **Long Press**: Hard Drop
