import pygame
from settings import *

def draw_text_middle(surface, text, size, color, y_offset=0):
    font = pygame.font.SysFont('comicsans', size, bold=True)
    label = font.render(text, 1, color)
    
    surface.blit(label, (SCREEN_WIDTH / 2 - label.get_width() / 2, SCREEN_HEIGHT / 2 - label.get_height() / 2 + y_offset))

def draw_text(surface, text, size, color, x, y):
    font = pygame.font.SysFont('comicsans', size, bold=True)
    label = font.render(text, 1, color)
    surface.blit(label, (x, y))

def draw_next_shape(surface, shape):
    font = pygame.font.SysFont('comicsans', 30)
    label = font.render('Next Shape', 1, TEXT_COLOR)

    sx = GRID_WIDTH + 50
    sy = 200
    
    surface.blit(label, (sx + 10, sy - 30))
    
    format = shape.shape[shape.rotation]
    
    for i, line in enumerate(format):
        # The shape format is a list of (x,y)
        # We need to normalize it to draw in the box
        # But wait, our shape definition is absolute coordinates relative to (0,0) of the piece?
        # No, the shape definition in settings.py is relative to a center (0,0) to (3,3)
        # Actually, let's look at settings.py again.
        # SHAPES['I'] = [[(0, 1), (1, 1), (2, 1), (3, 1)], ...]
        # These are coordinates.
        
        # We need to draw them relative to sx, sy
        # Let's just iterate the blocks
        pass
    
    # Correct iteration
    for block in format:
        x, y = block
        # Adjust for display
        pygame.draw.rect(surface, shape.color, (sx + x*BLOCK_SIZE, sy + y*BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE), 0)
        pygame.draw.rect(surface, BLACK, (sx + x*BLOCK_SIZE, sy + y*BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE), 1)

def draw_window(surface, grid, score=0, level=0, next_piece=None):
    surface.fill(BG_COLOR)
    
    # Title
    font = pygame.font.SysFont('comicsans', 60)
    label = font.render('TETRIS', 1, TEXT_COLOR)
    surface.blit(label, (SCREEN_WIDTH / 2 - label.get_width() / 2, 0))
    
    # Score
    font = pygame.font.SysFont('comicsans', 30)
    label = font.render('Score: ' + str(score), 1, TEXT_COLOR)
    sx = GRID_WIDTH + 100 # Moved right (+30)
    sy = 400 # Moved down significantly to avoid overlap
    surface.blit(label, (sx + 10, sy))

    # Level
    label = font.render('Level: ' + str(level), 1, TEXT_COLOR)
    surface.blit(label, (sx + 10, sy + 50))

    # Draw Grid
    grid.draw(surface)
    
    # Draw Next Piece
    if next_piece:
        draw_next_shape(surface, next_piece)
    
    # Draw Border around grid
    pygame.draw.rect(surface, BORDER_COLOR, (0, 0, GRID_WIDTH, GRID_HEIGHT), 2)
    
    # Update display
    # pygame.display.update() # Caller handles update
