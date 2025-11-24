import Foundation

protocol GameEngineDelegate: AnyObject {
    func didUpdateScore(score: Int, level: Int, lines: Int)
    func didUpdateNextPiece(piece: Tetromino)
    func didGameOver()
    func didUpdateGrid() // Request redraw
}

class GameEngine {
    var grid: Grid
    var currentPiece: Tetromino
    var nextPiece: Tetromino
    
    var score = 0
    var level = 1
    var linesClearedTotal = 0
    
    var isGameOver = false
    var isPaused = false
    
    var fallSpeed: TimeInterval
    var lastTickTime: TimeInterval = 0
    
    weak var delegate: GameEngineDelegate?
    
    init() {
        self.grid = Grid(width: GameSettings.cols, height: GameSettings.rows)
        self.currentPiece = Tetromino(type: TetrominoType.allCases.randomElement()!)
        self.nextPiece = Tetromino(type: TetrominoType.allCases.randomElement()!)
        self.fallSpeed = GameSettings.startSpeed
    }
    
    func start() {
        delegate?.didUpdateNextPiece(piece: nextPiece)
        delegate?.didUpdateScore(score: score, level: level, lines: linesClearedTotal)
    }
    
    func update(currentTime: TimeInterval) {
        if isGameOver || isPaused { return }
        
        if lastTickTime == 0 {
            lastTickTime = currentTime
            return
        }
        
        if currentTime - lastTickTime >= fallSpeed {
            lastTickTime = currentTime
            moveDown()
        }
    }
    
    func moveDown() {
        currentPiece.move(dx: 0, dy: 1)
        if !grid.isValid(piece: currentPiece) {
            currentPiece.move(dx: 0, dy: -1)
            lockPiece()
        }
        delegate?.didUpdateGrid()
    }
    
    func moveLeft() {
        if isGameOver || isPaused { return }
        currentPiece.move(dx: -1, dy: 0)
        if !grid.isValid(piece: currentPiece) {
            currentPiece.move(dx: 1, dy: 0)
        }
        delegate?.didUpdateGrid()
    }
    
    func moveRight() {
        if isGameOver || isPaused { return }
        currentPiece.move(dx: 1, dy: 0)
        if !grid.isValid(piece: currentPiece) {
            currentPiece.move(dx: -1, dy: 0)
        }
        delegate?.didUpdateGrid()
    }
    
    func rotate() {
        if isGameOver || isPaused { return }
        currentPiece.rotate()
        if !grid.isValid(piece: currentPiece) {
            currentPiece.undoRotate()
        }
        delegate?.didUpdateGrid()
    }
    
    func hardDrop() {
        if isGameOver || isPaused { return }
        while grid.isValid(piece: currentPiece) {
            currentPiece.move(dx: 0, dy: 1)
        }
        currentPiece.move(dx: 0, dy: -1)
        lockPiece()
        delegate?.didUpdateGrid()
    }
    
    private func lockPiece() {
        grid.add(piece: currentPiece)
        let cleared = grid.clearRows()
        updateScore(lines: cleared)
        
        currentPiece = nextPiece
        nextPiece = Tetromino(type: TetrominoType.allCases.randomElement()!)
        delegate?.didUpdateNextPiece(piece: nextPiece)
        
        if !grid.isValid(piece: currentPiece) {
            isGameOver = true
            delegate?.didGameOver()
        }
    }
    
    private func updateScore(lines: Int) {
        if lines > 0 {
            score += GameSettings.scorePerLine[lines] * level
            linesClearedTotal += lines
            
            if linesClearedTotal / 10 >= level {
                level += 1
                fallSpeed = max(GameSettings.minSpeed, fallSpeed - GameSettings.speedDecrement)
            }
            delegate?.didUpdateScore(score: score, level: level, lines: linesClearedTotal)
        }
    }
    
    func restart() {
        grid.reset()
        score = 0
        level = 1
        linesClearedTotal = 0
        fallSpeed = GameSettings.startSpeed
        isGameOver = false
        isPaused = false
        currentPiece = Tetromino(type: TetrominoType.allCases.randomElement()!)
        nextPiece = Tetromino(type: TetrominoType.allCases.randomElement()!)
        start()
        delegate?.didUpdateGrid()
    }
}
