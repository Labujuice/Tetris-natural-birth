import SpriteKit

struct GameSettings {
    static let rows = 20
    static let cols = 10
    static let blockSize: CGFloat = 30.0
    
    // Colors
    static let bgColor = SKColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    static let gridColor = SKColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    
    // Speed
    static let startSpeed: TimeInterval = 0.5 // Seconds per tick
    static let minSpeed: TimeInterval = 0.05
    static let speedDecrement: TimeInterval = 0.005
    
    // Scoring
    static let scorePerLine = [0, 100, 300, 500, 800] // 0, 1, 2, 3, 4 lines
}
