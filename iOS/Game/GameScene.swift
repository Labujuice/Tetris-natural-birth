import SpriteKit

class GameScene: SKScene, GameEngineDelegate {
    
    var gameEngine: GameEngine!
    
    // Nodes
    var gridNode: SKNode!
    var pieceNode: SKNode!
    var scoreLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    
    // Metrics
    var blockSize: CGFloat = 30.0
    var gridOrigin: CGPoint = .zero
    
    override func didMove(to view: SKView) {
        backgroundColor = GameSettings.bgColor
        
        // Setup Nodes
        setupUI()
        
        // Start Game
        gameEngine = GameEngine()
        gameEngine.delegate = self
        gameEngine.start()
    }
    
    func setupUI() {
        // Calculate block size based on screen width
        let margin: CGFloat = 20.0
        let availableWidth = size.width - (margin * 2)
        blockSize = availableWidth / CGFloat(GameSettings.cols)
        
        // Center grid
        let gridWidth = blockSize * CGFloat(GameSettings.cols)
        let gridHeight = blockSize * CGFloat(GameSettings.rows)
        let startX = (size.width - gridWidth) / 2
        let startY = (size.height - gridHeight) / 2
        gridOrigin = CGPoint(x: startX, y: startY)
        
        // Grid Node
        gridNode = SKNode()
        gridNode.position = gridOrigin
        addChild(gridNode)
        
        // Piece Node
        pieceNode = SKNode()
        pieceNode.position = gridOrigin
        addChild(pieceNode)
        
        // Labels
        scoreLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 50)
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
        levelLabel.text = "Level: 1"
        levelLabel.fontSize = 20
        levelLabel.position = CGPoint(x: size.width / 2, y: size.height - 80)
        addChild(levelLabel)
        
        gameOverLabel = SKLabelNode(fontNamed: "Avenir-Black")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOverLabel.isHidden = true
        gameOverLabel.zPosition = 100
        addChild(gameOverLabel)
        
        // Draw Grid Background
        let bg = SKShapeNode(rect: CGRect(x: 0, y: 0, width: gridWidth, height: gridHeight))
        bg.fillColor = GameSettings.gridColor
        bg.strokeColor = .white
        bg.lineWidth = 2
        gridNode.addChild(bg)
    }
    
    override func update(_ currentTime: TimeInterval) {
        gameEngine.update(currentTime: currentTime)
    }
    
    // MARK: - Rendering
    
    func drawGrid() {
        gridNode.removeAllChildren()
        
        // Re-draw background border
        let gridWidth = blockSize * CGFloat(GameSettings.cols)
        let gridHeight = blockSize * CGFloat(GameSettings.rows)
        let bg = SKShapeNode(rect: CGRect(x: 0, y: 0, width: gridWidth, height: gridHeight))
        bg.strokeColor = .white
        bg.lineWidth = 2
        gridNode.addChild(bg)
        
        // Draw locked blocks
        for y in 0..<GameSettings.rows {
            for x in 0..<GameSettings.cols {
                if let color = gameEngine.grid.grid[y][x] {
                    let node = SKShapeNode(rect: CGRect(x: CGFloat(x) * blockSize, y: CGFloat(GameSettings.rows - 1 - y) * blockSize, width: blockSize, height: blockSize))
                    node.fillColor = color
                    node.strokeColor = .black
                    node.lineWidth = 1
                    gridNode.addChild(node)
                }
            }
        }
    }
    
    func drawCurrentPiece() {
        pieceNode.removeAllChildren()
        let piece = gameEngine.currentPiece
        for pos in piece.getAbsolutePositions() {
            let x = pos.0
            let y = pos.1
            // In SpriteKit, (0,0) is bottom-left. In our grid, (0,0) is top-left usually.
            // Let's invert Y for rendering:
            // Grid Y=0 is Top. Screen Y needs to be High.
            // ScreenY = (Rows - 1 - GridY) * BlockSize
            
            if y >= 0 && y < GameSettings.rows {
                let node = SKShapeNode(rect: CGRect(x: CGFloat(x) * blockSize, y: CGFloat(GameSettings.rows - 1 - y) * blockSize, width: blockSize, height: blockSize))
                node.fillColor = piece.color
                node.strokeColor = .white
                node.lineWidth = 1
                pieceNode.addChild(node)
            }
        }
    }
    
    // MARK: - Delegate Methods
    
    func didUpdateScore(score: Int, level: Int, lines: Int) {
        scoreLabel.text = "Score: \(score)"
        levelLabel.text = "Level: \(level)"
    }
    
    func didUpdateNextPiece(piece: Tetromino) {
        // Optional: Draw next piece preview
    }
    
    func didGameOver() {
        gameOverLabel.isHidden = false
    }
    
    func didUpdateGrid() {
        drawGrid()
        drawCurrentPiece()
    }
    
    // MARK: - Input Handlers (Called from VC)
    
    func handleTap() {
        if gameEngine.isGameOver {
            gameEngine.restart()
            gameOverLabel.isHidden = true
        } else {
            gameEngine.rotate()
        }
    }
    
    func handleSwipeLeft() {
        gameEngine.moveLeft()
    }
    
    func handleSwipeRight() {
        gameEngine.moveRight()
    }
    
    func handleSwipeDown() {
        gameEngine.moveDown() // Soft drop
    }
    
    func handleLongPress() {
        gameEngine.hardDrop()
    }
}
