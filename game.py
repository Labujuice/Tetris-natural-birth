import pygame
from settings import *
from grid import Grid
from tetromino import Tetromino
from leaderboard import Leaderboard
import ui

class Game:
    def __init__(self, surface):
        self.surface = surface
        self.grid = Grid()
        self.leaderboard = Leaderboard()
        
        self.score = 0
        self.level = 1
        self.lines_cleared_total = 0
        
        self.current_piece = self.get_new_piece()
        self.next_piece = self.get_new_piece()
        
        self.game_over = False
        self.paused = False
        
        self.fall_speed = START_SPEED
        self.fall_time = 0
        self.clock = pygame.time.Clock()
        
        self.player_name = ""

    def get_new_piece(self):
        return Tetromino(5, 0)

    def update_score(self, lines_cleared):
        if lines_cleared > 0:
            self.score += SCORE_PER_LINE[lines_cleared] * self.level
            self.lines_cleared_total += lines_cleared
            
            # Level up every 10 lines
            if self.lines_cleared_total // 10 >= self.level:
                self.level += 1
                self.fall_speed = max(MIN_SPEED, self.fall_speed - SPEED_DECREMENT)

    def handle_input(self):
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                return False
            
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_LEFT:
                    self.current_piece.move(-1, 0)
                    if not self.grid.is_valid_position(self.current_piece):
                        self.current_piece.move(1, 0)
                
                elif event.key == pygame.K_RIGHT:
                    self.current_piece.move(1, 0)
                    if not self.grid.is_valid_position(self.current_piece):
                        self.current_piece.move(-1, 0)
                
                # K_DOWN is handled in the main loop for continuous input
                
                elif event.key == pygame.K_UP:
                    self.current_piece.rotate()
                    if not self.grid.is_valid_position(self.current_piece):
                        self.current_piece.undo_rotate()
                
                elif event.key == pygame.K_p:
                    self.paused = not self.paused
                        
        return True

    def run(self):
        run = True
        while run:
            self.fall_time += self.clock.get_rawtime()
            self.clock.tick()

            # Game Loop
            if not self.game_over:
                if self.paused:
                    ui.draw_text_middle(self.surface, "PAUSED", 60, WHITE)
                    pygame.display.update()
                    # Still handle input to unpause
                    run = self.handle_input()
                    continue

                # Check for soft drop
                keys = pygame.key.get_pressed()
                current_speed = self.fall_speed
                if keys[pygame.K_DOWN]:
                    current_speed = 50 # Fast drop speed
                
                # Fall logic
                if self.fall_time / 1000 * 1000 >= current_speed:
                    self.fall_time = 0
                    self.current_piece.move(0, 1)
                    if not self.grid.is_valid_position(self.current_piece):
                        self.current_piece.move(0, -1)
                        self.grid.add_piece(self.current_piece)
                        
                        cleared = self.grid.clear_rows_robust()
                        self.update_score(cleared)
                        
                        self.current_piece = self.next_piece
                        self.next_piece = self.get_new_piece()
                        
                        if not self.grid.is_valid_position(self.current_piece):
                            self.game_over = True

                run = self.handle_input()
                
                # Draw
                ui.draw_window(self.surface, self.grid, self.score, self.level, self.next_piece)
                
                # Draw current piece on top of grid
                # We need to manually draw it here because it's not in the grid yet
                for pos in self.current_piece.get_positions():
                    x, y = pos
                    if y > -1:
                        pygame.draw.rect(self.surface, self.current_piece.color, 
                                         (x * BLOCK_SIZE, y * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE), 0)

            else:
                # Game Over Screen
                self.surface.fill(BG_COLOR) # Clear screen to prevent stacking
                ui.draw_text_middle(self.surface, "GAME OVER", 60, WHITE, -100)
                ui.draw_text_middle(self.surface, "Enter Name: " + self.player_name, 30, WHITE, 0)
                
                # Display Leaderboard
                top_scores = self.leaderboard.get_top_scores()
                y_off = 50
                for idx, entry in enumerate(top_scores[:5]):
                    text = f"{idx+1}. {entry['name']}: {entry['score']}"
                    ui.draw_text_middle(self.surface, text, 20, WHITE, y_off + idx * 25)

                pygame.display.update()
                
                for event in pygame.event.get():
                    if event.type == pygame.QUIT:
                        run = False
                    if event.type == pygame.KEYDOWN:
                        if event.key == pygame.K_RETURN:
                            # Save score
                            if self.player_name:
                                self.leaderboard.add_score(self.player_name, self.score)
                            # Restart
                            self.__init__(self.surface)
                        elif event.key == pygame.K_BACKSPACE:
                            self.player_name = self.player_name[:-1]
                        else:
                            # Add character
                            if len(self.player_name) < 10:
                                self.player_name += event.unicode
            
            pygame.display.update()
        
        pygame.quit()
