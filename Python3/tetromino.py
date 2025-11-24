import random
from settings import *

class Tetromino:
    def __init__(self, x, y, shape_type=None):
        self.x = x
        self.y = y
        if shape_type is None:
            self.shape_type = random.choice(list(SHAPES.keys()))
        else:
            self.shape_type = shape_type
        
        self.shape = SHAPES[self.shape_type]
        self.color = SHAPE_COLORS[self.shape_type]
        self.rotation = 0 # 0 to 3

    def rotate(self):
        self.rotation = (self.rotation + 1) % len(self.shape)

    def undo_rotate(self):
        self.rotation = (self.rotation - 1) % len(self.shape)

    def get_positions(self):
        """Returns a list of (x, y) tuples for the current block positions on the grid."""
        positions = []
        shape_matrix = self.shape[self.rotation]
        for block_x, block_y in shape_matrix:
            positions.append((self.x + block_x, self.y + block_y))
        return positions

    def move(self, dx, dy):
        self.x += dx
        self.y += dy
