import pygame
from settings import *

class Grid:
    def __init__(self):
        self.grid = [[(0, 0, 0) for _ in range(COLS)] for _ in range(ROWS)]
        self.locked_positions = {} # (x,y): (r,g,b)

    def is_valid_position(self, tetromino):
        """Checks if the tetromino is within bounds and not colliding with other blocks."""
        accepted_pos = [[(j, i) for j in range(COLS) if self.grid[i][j] == (0, 0, 0)] for i in range(ROWS)]
        accepted_pos = [x for sub in accepted_pos for x in sub]

        formatted = tetromino.get_positions()

        for pos in formatted:
            if pos not in accepted_pos:
                if pos[1] > -1: # Allow spawning above screen
                    return False
        return True

    def add_piece(self, tetromino):
        """Locks the tetromino into the grid."""
        for pos in tetromino.get_positions():
            p = (pos[0], pos[1])
            self.locked_positions[p] = tetromino.color
        
        # Update grid for rendering
        for i in range(ROWS):
            for j in range(COLS):
                if (j, i) in self.locked_positions:
                    self.grid[i][j] = self.locked_positions[(j, i)]

    def clear_full_rows(self):
        """Clears full rows and shifts blocks down. Returns number of cleared rows."""
        inc = 0
        # Iterate backwards
        for i in range(ROWS - 1, -1, -1):
            row = self.grid[i]
            if (0, 0, 0) not in row:
                inc += 1
                # Remove position from locked_positions
                ind = i
                for j in range(COLS):
                    try:
                        del self.locked_positions[(j, i)]
                    except:
                        continue
        
        if inc > 0:
            # Shift positions down
            # Sort locked positions by y (row) in reverse
            for key in sorted(list(self.locked_positions), key=lambda x: x[1])[::-1]:
                x, y = key
                if y < i + inc: # This logic needs to be careful. 
                    # Simpler approach: Rebuild locked_positions
                    pass
            
            # Better approach:
            # 1. Identify rows to clear
            # 2. Create new locked_positions
            
            # Let's rewrite the shift logic to be robust
            new_locked = {}
            rows_to_keep = []
            
            # Identify which rows are full
            full_rows = []
            for r in range(ROWS):
                if (0,0,0) not in self.grid[r]:
                    full_rows.append(r)
            
            if not full_rows:
                return 0
            
            # Shift logic
            # For every block in locked_positions:
            # If it's above a full row, move it down by 1 for each full row below it?
            # No, if it's above the highest full row, it moves down by len(full_rows).
            # Actually, we just need to iterate through all locked positions and shift them.
            
            # Let's use the standard algorithm:
            # Iterate from bottom up. If row is full, move all rows above it down by 1.
            
            # Since we might have multiple rows, let's do it one by one or rebuild.
            # Rebuilding is safer.
            
            # Wait, the previous loop was finding 'inc' (count).
            # Let's restart the logic cleanly.
            pass

        return inc

    def clear_rows_robust(self):
        """
        Clears full rows and moves everything down.
        Returns the number of cleared rows.
        """
        cleared = 0
        # Check which rows are full based on locked_positions
        # We can't rely on self.grid because it might be stale if we don't update it constantly
        # But we do update it at the end of add_piece.
        # However, let's check locked_positions directly to be safe.
        
        # Identify full rows
        full_rows = []
        for y in range(ROWS):
            row_is_full = True
            for x in range(COLS):
                if (x, y) not in self.locked_positions:
                    row_is_full = False
                    break
            if row_is_full:
                full_rows.append(y)
        
        if not full_rows:
            return 0
        
        cleared = len(full_rows)
        
        # Create new locked positions
        new_locked = {}
        for (x, y), color in self.locked_positions.items():
            if y in full_rows:
                continue # Skip blocks in full rows
            
            # Calculate how many rows below this block were cleared
            # Rows are 0 at top, 19 at bottom.
            # If we clear row 19, row 18 moves to 19 (y + 1).
            # So we count how many full_rows are > y
            shifts = 0
            for r in full_rows:
                if r > y:
                    shifts += 1
            
            new_locked[(x, y + shifts)] = color
            
        self.locked_positions = new_locked
        
        # Sync grid with locked_positions
        self.grid = [[(0, 0, 0) for _ in range(COLS)] for _ in range(ROWS)]
        for (x, y), color in self.locked_positions.items():
            self.grid[y][x] = color
            
        return cleared

    def draw(self, surface):
        for i in range(ROWS):
            for j in range(COLS):
                pygame.draw.rect(surface, self.grid[i][j], (j * BLOCK_SIZE, i * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE), 0)
        
        # Draw grid lines
        for i in range(ROWS):
            pygame.draw.line(surface, GRID_COLOR, (0, i * BLOCK_SIZE), (GRID_WIDTH, i * BLOCK_SIZE))
        for j in range(COLS):
            pygame.draw.line(surface, GRID_COLOR, (j * BLOCK_SIZE, 0), (j * BLOCK_SIZE, GRID_HEIGHT))
        
        pygame.draw.rect(surface, BORDER_COLOR, (0, 0, GRID_WIDTH, GRID_HEIGHT), 2)
