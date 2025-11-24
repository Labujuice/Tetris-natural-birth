import pygame
from settings import *
from game import Game

def main():
    pygame.init()
    pygame.font.init()
    
    win = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption('Tetris')
    
    game = Game(win)
    game.run()

if __name__ == '__main__':
    main()
