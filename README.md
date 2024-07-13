# Duck-Hunt

### Overview
Duck-Hunt is an 8086 Assembly Language (Masm) game. The code has some flaws but functions as intended. Open to collaborations and insights.

### Gameplay
- **Startup:** Press Enter, input your name, and proceed to the main screen.
- **Options:** 
  - 'a' for Mode One (one duck, slow movement)
  - 'b' for Mode Two (three ducks, fast movement)
  - 's' for Instructions
  - 'x' for Exit

- **Mode One:**
  - Move the dot using arrow keys, aim at the duck, and press Enter to score.
  - Levels: Score 5 to complete level one, 10 for level two, and 20 to finish mode.

- **Mode Two:** Same logic as Mode One, but with three fast-moving ducks.

- **Navigation:** Use Backspace to return to the previous screen.

### How to Run
1. Install Masm615 and Dosbox.
2. Place `result.asm` in Masm615's BIN directory.
3. Open Dosbox and run:
