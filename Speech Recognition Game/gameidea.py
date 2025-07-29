import speech_recognition as sr
import pygame
import sys

# Initialize the game
pygame.init()

# Set up the screen
screen_width = 800
screen_height = 600
screen = pygame.display.set_mode((screen_width, screen_height))

# Set up the character
character_width = 50
character_height = 50
character_x = (screen_width - character_width) // 2  # Center the character horizontally
character_y = (screen_height - character_height) // 2  # Center the character vertically
character = pygame.Rect(character_x, character_y, character_width, character_height)

# Set up the chest
chest_width = 100
chest_height = 100
chest_x = 0  # Left corner of the screen
chest_y = 0  # Top corner of the screen
chest = pygame.Rect(chest_x, chest_y, chest_width, chest_height)

# Define colors
brown = (139, 69, 19)
white = (255, 255, 255)

# Initialize the voice recognition module
recognizer = sr.Recognizer()

# Define game states
STATE_MENU = 0
STATE_GAME = 1

# Set initial game state
game_state = STATE_MENU

# Create a font for the menu
menu_font = pygame.font.Font(None, 36)

# Create a button for starting the game
start_button = pygame.Rect(screen_width // 2 - 50, screen_height // 2 - 25, 100, 50)

def handle_voice_command():
    with sr.Microphone() as source:
        print("Listening...")
        recognizer.adjust_for_ambient_noise(source)
        audio = recognizer.listen(source)

    try:
        command = recognizer.recognize_google(audio)
        print("You said:", command)
        if command.lower() == "jump":
            character.y -= 50  # Move the character up by 50 pixels
        elif command.lower() == "down":
            character.y += 50  # Move the character down by 50 pixels
        elif command.lower() == "right":
            character.x += 50  # Move the character right by 50 pixels
        elif command.lower() == "left":
            character.x -= 50  # Move the character left by 50 pixels
        elif command.lower() == "open":
            # Check if the character is close enough to the chest
            if character.colliderect(chest):
                print("Chest opened!")
                # Add your desired logic for when the chest is opened here
            else:
                print("You are not close enough to the chest!")
    except sr.UnknownValueError:
        print("Oops! Could not understand audio.")
    except sr.RequestError as e:
        print("Uh oh! Could not request results from Google Speech Recognition service:", e)

# Game loop
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
            if game_state == STATE_MENU and start_button.collidepoint(event.pos):
                game_state = STATE_GAME

    if game_state == STATE_MENU:
        handle_voice_command()

        # Update the screen
        screen.fill((0, 0, 0))  # Fill the screen with black color
        pygame.draw.rect(screen, brown, chest)  # Draw the chest as a brown rectangle
        
        # Draw the menu text and start button
        menu_text = menu_font.render("Voice Recognition Game", True, white)
        text_rect = menu_text.get_rect(center=(screen_width // 2, screen_height // 2 - 50))
        screen.blit(menu_text, text_rect)
        
        start_text = menu_font.render("Start", True, white)
        start_rect = start_text.get_rect(center=(screen_width // 2, screen_height // 2))
        screen.blit(start_text, start_rect)
        pygame.draw.rect(screen, white, start_button, 2)
        
        pygame.display.flip()  # Update the display
        
    elif game_state == STATE_GAME:
        handle_voice_command()

        # Update the screen
        screen.fill((0, 0, 0))  # Fill the screen with black color
        pygame.draw.rect(screen, brown, chest)  # Draw the chest as a brown rectangle
        pygame.draw.rect(screen, (255, 0, 0), character)  # Draw the character as a red rectangle
        pygame.display.flip()  # Update the display

# Quit the game
pygame.quit()
sys.exit()
