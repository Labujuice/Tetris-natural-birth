# How to Build the iOS App

Since I cannot generate the `.xcodeproj` file directly (it requires Xcode on macOS), you need to create the project shell and import the files I generated.

## Prerequisites
- A Mac with **Xcode** installed.

## Steps

### 1. Create a New Xcode Project
1.  Open Xcode.
2.  Select **Create a new Xcode project**.
3.  Choose **iOS** -> **App**.
4.  Click **Next**.
5.  **Product Name**: `TetrisDIY` (or whatever you like).
6.  **Interface**: **Storyboard** (Important! My code assumes a standard View Controller setup, though we use SpriteKit programmatically).
    *   *Alternative*: You can choose **SpriteKit** Game template, but you'll need to replace their `GameScene.swift` and `GameViewController.swift` with mine. **Recommendation: Choose "Game" template with Language: Swift, Game Technology: SpriteKit.**
7.  Click **Next** and save it somewhere (e.g., Desktop).

### 2. Import Files
1.  Open your new Xcode project.
2.  Locate the `iOS` folder I created in this repository: `tetris_diy/iOS`.
3.  Drag the **contents** of my `iOS` folder (`Models`, `Game`, `ViewControllers`) into your Xcode project navigator (the left sidebar).
    *   **Important**: When prompted, check **"Copy items if needed"** and select **"Create groups"**.
    *   Ensure your App Target is checked in "Add to targets".

### 3. Link the View Controller
If you chose the **Game** template:
1.  Delete the default `GameScene.swift`, `GameViewController.swift`, `Actions.sks`, `GameScene.sks` provided by Xcode.
2.  My `GameViewController.swift` and `GameScene.swift` should now be the ones used.
3.  Open `Main.storyboard`.
4.  Select the View Controller.
5.  In the **Identity Inspector** (right sidebar, 3rd icon), make sure **Class** is set to `GameViewController`.
6.  In the **Attribute Inspector**, ensure the root view is of type `SKView`. (If you used the Game template, this is already done).

### 4. Build and Run
1.  Select a Simulator (e.g., iPhone 15 Pro).
2.  Press **Cmd + R** or click the Play button.
3.  The game should launch!

## Controls
- **Tap**: Rotate
- **Swipe Left/Right**: Move
- **Swipe Down**: Soft Drop
- **Long Press**: Hard Drop
