import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        // Create and configure the scene
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // Present the scene
        skView.presentScene(scene)
        
        setupGestures(view: skView, scene: scene)
    }
    
    func setupGestures(view: UIView, scene: GameScene) {
        // Tap to Rotate
        let tap = UITapGestureRecognizer(target: scene, action: #selector(GameScene.handleTap))
        view.addGestureRecognizer(tap)
        
        // Swipe Left
        let swipeLeft = UISwipeGestureRecognizer(target: scene, action: #selector(GameScene.handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        // Swipe Right
        let swipeRight = UISwipeGestureRecognizer(target: scene, action: #selector(GameScene.handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        // Swipe Down (Soft Drop)
        let swipeDown = UISwipeGestureRecognizer(target: scene, action: #selector(GameScene.handleSwipeDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        // Long Press (Hard Drop)
        let longPress = UILongPressGestureRecognizer(target: scene, action: #selector(GameScene.handleLongPress))
        longPress.minimumPressDuration = 0.2
        view.addGestureRecognizer(longPress)
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
