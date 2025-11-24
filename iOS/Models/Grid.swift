import SpriteKit

class Grid {
    let width: Int
    let height: Int
    var grid: [[SKColor?]]
    
    init(width: Int = 10, height: Int = 20) {
        self.width = width
        self.height = height
        // Initialize empty grid
        self.grid = Array(repeating: Array(repeating: nil, count: width), count: height)
    }
    
    func isValid(piece: Tetromino) -> Bool {
        for pos in piece.getAbsolutePositions() {
            let x = pos.0
            let y = pos.1
            
            // Check boundaries
            if x < 0 || x >= width || y >= height {
                return false
            }
            
            // Check collision with existing blocks
            // Note: y < 0 is valid (above screen) for spawning, but usually we check if it overlaps.
            // If y is negative, it's just above the board, which is technically "valid" until it locks.
            // But if we want to prevent moving INTO existing blocks:
            if y >= 0 {
                if grid[y][x] != nil {
                    return false
                }
            }
        }
        return true
    }
    
    func add(piece: Tetromino) {
        for pos in piece.getAbsolutePositions() {
            let x = pos.0
            let y = pos.1
            if y >= 0 && y < height && x >= 0 && x < width {
                grid[y][x] = piece.color
            }
        }
    }
    
    func clearRows() -> Int {
        var linesCleared = 0
        var y = height - 1
        while y >= 0 {
            var isFull = true
            for x in 0..<width {
                if grid[y][x] == nil {
                    isFull = false
                    break
                }
            }
            
            if isFull {
                linesCleared += 1
                // Move everything down
                for moveY in (0..<y).reversed() {
                    grid[moveY + 1] = grid[moveY]
                }
                // Clear top row
                grid[0] = Array(repeating: nil, count: width)
                // Don't decrement y, check this row index again (since it's now the row from above)
            } else {
                y -= 1
            }
        }
        return linesCleared
    }
    
    func reset() {
        self.grid = Array(repeating: Array(repeating: nil, count: width), count: height)
    }
}
