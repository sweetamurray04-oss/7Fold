7Fold 

# Overview 

7Fold is a horror aesthetic platformer game centered around a character who is caught in limbo. To rest peacefully, the character must face their seven deadly sins. 

## Features 
User control player movement 
Engaging sound effects 
Immediate feedback loop
Survival focused level 
Minimalist- visual style 

## Timeline 
5 weeks 

## Framework
SwiftUI
SpriteKit
GameplayKit
AVFoundation


## Development Journey 

This project tested my endurance when things got difficult. After building my confidence from past projects, I came to this challenge pretty confident in my skills. This changed when I was introduced to SpriteKit, a framework used for building games in Swift. I discovered game coding concepts such as physics, animation, and sound effects. I continued to use guiding questions such as 
“How do I animate the character walking?”
“How do I add sound effects to the character movement?”
“How do I incorporate parallax scrolling in the game?” to help me find solutions.
Collaborating with the lead coder, we used resources such as Apple’s documentation, Stack Overflow, and video tutorials to understand concepts and apply them to build 7Fold.

<img width="500" height="500" alt="Screenshot 2026-03-23 at 8 27 04 PM" src="https://github.com/user-attachments/assets/20c0a56a-2991-4fa4-946c-d9ae6e47854e" />

<img width="500" height="500" alt="Screenshot 2026-03-23 at 8 27 55 PM" src="https://github.com/user-attachments/assets/fde7cd8b-5b42-4b19-91b2-6beb38bb5984" />

To add sound effects and background music to the game, I created a seperate file and implemented the framework AVFoundation. Then I created a class called SoundMnager with functions such as sound effects, background music, and stop. I did this because I didn't want mixed them together and created confusion.

<img width="500" height="500" alt="Screenshot 2026-03-23 at 8 29 17 PM" src="https://github.com/user-attachments/assets/f1631822-ac74-4263-b1a3-c4fcc0934d2e" />

Inside my game scene or character extension, I added specific sound effects or background music based on what is happening in the game. For example, there is a die function if the player gets captured by the demon, I triggered a scream sound effect to make the game more immersive and show that the character has passed.

I also added a stop function to make sure the sound don't keep playing longer than they should especially if the action or part of the game is finished.

<img width="753" height="421" alt="Screenshot 2026-03-29 at 6 04 41 PM" src="https://github.com/user-attachments/assets/cd6e6312-d55c-4b3f-8b16-fe503fa629df" />
<img width="1318" height="995" alt="Screenshot 2026-03-29 at 6 05 06 PM" src="https://github.com/user-attachments/assets/f7bf8afc-a709-4e56-b7cd-8af782345316" />
<img width="1319" height="993" alt="Screenshot 2026-03-29 at 6 05 30 PM" src="https://github.com/user-attachments/assets/95c73341-b73f-4b41-ab2a-5f2abe33ec9f" />


