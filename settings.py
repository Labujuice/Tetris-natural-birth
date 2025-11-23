import pygame

# Screen dimensions
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 700
GRID_WIDTH = 300
GRID_HEIGHT = 600
BLOCK_SIZE = 30

# Grid dimensions
COLS = 10
ROWS = 20

# Colors (R, G, B)
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
GRAY = (128, 128, 128)
DARK_GRAY = (50, 50, 50)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 0, 255)
CYAN = (0, 255, 255)
MAGENTA = (255, 0, 255)
YELLOW = (255, 255, 0)
ORANGE = (255, 165, 0)

# UI Colors
BG_COLOR = (20, 20, 20)
GRID_COLOR = (40, 40, 40)
BORDER_COLOR = WHITE
TEXT_COLOR = WHITE

# Tetromino Shapes
# 0: Empty
# Shapes are defined as lists of (x, y) coordinates relative to a center
SHAPES = {
    'I': [
        [(0, 1), (1, 1), (2, 1), (3, 1)],
        [(2, 0), (2, 1), (2, 2), (2, 3)],
        [(0, 2), (1, 2), (2, 2), (3, 2)],
        [(1, 0), (1, 1), (1, 2), (1, 3)]
    ],
    'J': [
        [(0, 0), (0, 1), (1, 1), (2, 1)],
        [(1, 0), (2, 0), (1, 1), (1, 2)],
        [(0, 1), (1, 1), (2, 1), (2, 2)],
        [(1, 0), (1, 1), (0, 2), (1, 2)]
    ],
    'L': [
        [(2, 0), (0, 1), (1, 1), (2, 1)],
        [(1, 0), (1, 1), (1, 2), (2, 2)],
        [(0, 1), (1, 1), (2, 1), (0, 2)],
        [(0, 0), (1, 0), (1, 1), (1, 2)]
    ],
    'O': [
        [(1, 0), (2, 0), (1, 1), (2, 1)]
    ],
    'S': [
        [(1, 0), (2, 0), (0, 1), (1, 1)],
        [(1, 0), (1, 1), (2, 1), (2, 2)],
        [(1, 1), (2, 1), (0, 2), (1, 2)],
        [(0, 0), (0, 1), (1, 1), (1, 2)]
    ],
    'T': [
        [(1, 0), (0, 1), (1, 1), (2, 1)],
        [(1, 0), (1, 1), (2, 1), (1, 2)],
        [(0, 1), (1, 1), (2, 1), (1, 2)],
        [(1, 0), (0, 1), (1, 1), (1, 2)]
    ],
    'Z': [
        [(0, 0), (1, 0), (1, 1), (2, 1)],
        [(2, 0), (1, 1), (2, 1), (1, 2)],
        [(0, 1), (1, 1), (1, 2), (2, 2)],
        [(1, 0), (0, 1), (0, 2), (1, 1)]
    ]
}

SHAPE_COLORS = {
    'I': CYAN,
    'J': BLUE,
    'L': ORANGE,
    'O': YELLOW,
    'S': GREEN,
    'T': MAGENTA,
    'Z': RED
}

# Game Settings
FPS = 60
START_SPEED = 500  # Milliseconds per step
SPEED_DECREMENT = 20 # Decrease delay by this much per level
MIN_SPEED = 100
SCORE_PER_LINE = [0, 100, 300, 500, 800] # 0, 1, 2, 3, 4 lines

# Feature Flags
DRAW_GRID_LINES_ON_PIECE = True
