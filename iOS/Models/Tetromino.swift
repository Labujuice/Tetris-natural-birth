import SpriteKit

enum TetrominoType: CaseIterable {
    case I, O, T, S, Z, J, L
}

struct Tetromino {
    let type: TetrominoType
    var color: SKColor
    var blocks: [(Int, Int)] // Relative coordinates
    var x: Int
    var y: Int
    var rotationIndex: Int = 0
    
    init(type: TetrominoType, startX: Int = 5, startY: Int = 0) {
        self.type = type
        self.x = startX
        self.y = startY
        
        switch type {
        case .I:
            self.color = .cyan
            self.blocks = [(0, 1), (1, 1), (2, 1), (3, 1)]
        case .O:
            self.color = .yellow
            self.blocks = [(1, 0), (2, 0), (1, 1), (2, 1)]
        case .T:
            self.color = .purple
            self.blocks = [(1, 0), (0, 1), (1, 1), (2, 1)]
        case .S:
            self.color = .green
            self.blocks = [(1, 0), (2, 0), (0, 1), (1, 1)]
        case .Z:
            self.color = .red
            self.blocks = [(0, 0), (1, 0), (1, 1), (2, 1)]
        case .J:
            self.color = .blue
            self.blocks = [(0, 0), (0, 1), (1, 1), (2, 1)]
        case .L:
            self.color = .orange
            self.blocks = [(2, 0), (0, 1), (1, 1), (2, 1)]
        }
    }
    
    mutating func move(dx: Int, dy: Int) {
        self.x += dx
        self.y += dy
    }
    
    // Simple rotation algorithm: Rotate around a pivot.
    // For simplicity in this grid system, we often use hardcoded wall kicks or SRS, 
    // but for a basic version, we can just rotate relative coords.
    // Rotating 90 degrees clockwise: (x, y) -> (-y, x)
    // But we need a pivot. Usually the center of the bounding box.
    // Simplified approach: Hardcoded shapes for each rotation state is better for Tetris,
    // but to keep it dynamic like the Python version, we'll try math rotation.
    // Note: The Python version used a `figures` list of lists.
    // Let's stick to the Python logic if possible, but Swift is strongly typed.
    // Actually, let's implement a standard rotation:
    // NewX = -OldY
    // NewY = OldX
    // But this is around (0,0).
    // We need to rotate around a "center" block.
    // For I piece, it's tricky.
    // Let's use the Super Rotation System (SRS) simplified:
    // Just rotate relative to the "center" of the piece (e.g. block at index 2).
    
    mutating func rotate() {
        // Skip O piece
        if type == .O { return }
        
        // Pivot is usually the block at index 2 for T, S, Z, J, L.
        // For I, it's technically between blocks, which is hard in integer grid.
        // Let's use a simplified center: (1.5, 1.5) for 4x4 or (1,1) for 3x3.
        // Most pieces are inside a 3x3 box, except I (4x4) and O (2x2).
        
        // Let's try a simple approach: Rotate all blocks around (1.5, 1.5) or similar?
        // No, let's just do: (x, y) -> (size - 1 - y, x) for a matrix rotation.
        // But we store blocks as list of coords.
        
        // Let's assume a 4x4 bounding box for I, and 3x3 for others.
        let size = (type == .I) ? 4 : 3
        
        var newBlocks = [(Int, Int)]()
        for block in blocks {
            // Rotate 90 deg clockwise in a bounding box of 'size'
            // x' = size - 1 - y
            // y' = x
            // Wait, standard matrix rot 90 clockwise:
            // col = original_row
            // row = size - 1 - original_col
            // i.e. x_new = size - 1 - y_old
            //      y_new = x_old
            
            let nx = size - 1 - block.1
            let ny = block.0
            newBlocks.append((nx, ny))
        }
        self.blocks = newBlocks
    }
    
    mutating func undoRotate() {
        // Rotate 3 times or just reverse math
        // Counter-clockwise:
        // x_new = y_old
        // y_new = size - 1 - x_old
        if type == .O { return }
        let size = (type == .I) ? 4 : 3
        
        var newBlocks = [(Int, Int)]()
        for block in blocks {
            let nx = block.1
            let ny = size - 1 - block.0
            newBlocks.append((nx, ny))
        }
        self.blocks = newBlocks
    }
    
    func getAbsolutePositions() -> [(Int, Int)] {
        return blocks.map { ($0.0 + x, $0.1 + y) }
    }
}
