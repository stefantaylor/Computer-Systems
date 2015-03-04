


# ****** Question 1.2 ******

# ----------------------------------------------------------------------------------------------- #

# ****** Stefan Taylor -- s1006260 -- 26/10/2011 ******

# ----------------------------------------------------------------------------------------------- #

# ******
# freq.s -- A program that expects a string of characters ending with a $ symbol and counts 
# the  numeber of occurences of each character from a-z regardless of case (excluding space
# (' ', 0x20) tab ('\t', 0x09) newline ('\n',0x0a) carriage-return ('\r', 0x0d) and the final $)
# ******

# ----------------------------------------------------------------------------------------------- #

# ****** Registers used:
#			$s0 -- to hold the base address of "frequencies" array
#			$s1 -- to hold the address of the last word in "frequencies" array
#			$s2 -- to hold the ascii value of the letter to print
#			$s4 -- to represent the offset for the "frequencies" array when printing
#			$t0 -- used to store words from array
#			$a0 -- to hold the prompt
#			$v0 -- for syscall
# ******

# ----------------------------------------------------------------------------------------------- #

  .data
frequencies:	.byte		0:104
# ****** "frequencies" is an array which will store the number of occurences of each character.
# it requires 26 integers and is hence 104 bytes in length (as each integer requires 4 bytes.)
# and each value is initialised to 0 as there have been no occurences of any characters yet ******
prompt1:	.asciiz		"Enter text, followed by $:\n"
# ****** "prompt1" is the prompt the user gets upon running the program. ******

  .globl main  
  .text
main:
  li $v0, 4			# Sets Register $v0 to 4 so that syscall knows to output a string
  la $a0, prompt1		# Make $a0 point to prompt1
  syscall			# Call the OS to print prompt1
  la $s0, frequencies		# Register $s0 holds the base address of the "frequencies" array. It is a saved temporary as it will be used again.
  addi $s1, $s0, 100		# Register $s1 holds the address of the last word in the "frequencies" array. It is a saved temporary as it will be used again.

loop:				# The start of a loop reading every character of the input string.
  li $v0, 12			# Sets Register $v0 to 12, so that syscall knows to read a character.
  syscall			# Reads the next character. $v0 now holds that character.
  beq $v0, '$', print		# If the character is a $ sign then end loop and go to print
  bgt $v0, 96, lowercase	# If the characters ASCII code is greater than 96, it must be lowercase (if it is a letter), so branch to lowercase
  blt $v0, 91, uppercase	# If the characters ASCII code is less than 91, it must be uppercase (if it is a letter), so branch to uppercase
  j loop			# Jumps back to the loop to process next character

lowercase:			# Deals with lowercase letters
  bgt $v0, 123, loop		# If the character's ASCII code is not between 91 and 123, it is not a lowercase letter, so consider next character.
  sub $v0, $v0, 32		# Subtracting 32 gives the ASCII code for the same letter but uppercase.

uppercase:			# Deals with uppercase letters (including lowercase letters which have been changed to uppercase ones)
  blt $v0, 65, loop		# If The character's ASCII code is not between 65 and 91, it is not an Uppercase letter, so consider next character.
  sub $v0, $v0, 65		# Subtracting 65 gives the number of the letter in the alphabet (0-A, 1-B etc.).
  add $v0, $v0, $v0		# Equivilent to multiplying $v0 by 2
  add $v0, $v0, $v0		# Equivilent to multiplying $v0 by 4. Gives the offset for the byte address for the frequency of that letter in "frequency" in register $v0
  add $v0, $v0, $s0		# Adds the offset to the base address and stores new address at $v0
  lw $t0, ($v0)			# Stores the word at address $v0 in "frequencies" to $t0. This word represents the frequency of a letter.
  addi $t0, $t0, 1		# Adds 1 to $t0
  sw $t0, ($v0)			# Stores the updated value of $t0 back at $v0 in "frequencies". The frequency of the letter has been increased by one.
  j loop			# Jumps back to the loop to process next character

print:				# Prints the current letter followed by a colon, a space, the number of times it has occured (from "frequencies") and then a newline
  li $s2, 65			# Sets the value of Register $s2 to 65, corresponding to 'A'
  li $s4, 0			# Sets the value of Register $s4 to 0. This will be used to represent the offset for "frequencies".

printloop:			# The parts of print which need to be looped
  add $a0, $s2, $zero		# Sets $a0 to point to $s2
  li $v0, 11			# Sets the value of Register $v0 to 11, so that syscall knows to output a character.
  syscall			# Prints the character which corresponds to the value in $a0, which is the current letter
  li $v0, 11			# Sets the value of Register $v0 to 11, so that syscall knows to output a character.
  li $a0, 58			# Sets the value of Register $a0 to 58, which corresponds to a ":".
  syscall			# Prints a colon
  li $a0, 32			# Sets the value of Register $a0 to 32, which corresponds to a " " (space).
  li $v0, 11			# Sets the value of Register $v0 to 11, so that syscall knows to output a character.
  syscall			# Prints a space.
  li $v0, 1			# Sets v0 to 1 so that syscall knows to print an integer
  lw $a0, frequencies ($s4)	# Stores the word at the base address + $s4 of "frequencies" to $a0 using rich addressing. This word represents the frequency of a letter.
  syscall			# Prints the frequency of the current letter
  li $a0, 10			# Sets the value of Register $a0 to 10, which corresponds to a new line.
  li $v0, 11			# Sets the value of Register $v0 to 11, so that syscall knows to output a character.
  syscall			# Prints a new line
  addi $s2, $s2, 1		# Increases $s2 by 1 in order to increment the letter upon the next loop.
  addi $s4, $s4, 4		# Increases $s4 by 4 in order to access the next word
  blt $s2, 91, printloop	# Loops as long as $s2 is less than 91
  
exit:				# Exits the program
  li $v0, 10			# Sets $v0 to 10 so that syscall knows to end the program
  syscall			# End the program

# ----------------------------------------------------------------------------------------------- #

# ****************************   ___________   ___ _____  ____ ____   *************************** #
# ****************************  / ___/      | /  _]     |/    |    \  *************************** #
# **************************** (   \_|      |/  [_|   __|  o  |  _  | *************************** #
# ****************************  \__  |_|  |_|    _]  |_ |     |  |  | *************************** #
# ****************************  /  \ | |  | |   [_|   _]|  _  |  |  | *************************** #
# ****************************  \    | |  | |     |  |  |  |  |  |  | *************************** #
# ****************************   \___| |__| |_____|__|  |__|__|__|__| *************************** #

# ----------------------------------------------------------------------------------------------- #
                                      


