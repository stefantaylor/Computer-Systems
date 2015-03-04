


# ****** Question 1.1 ******

# ----------------------------------------------------------------------------------------------- #

# ****** Stefan Taylor -- s1006260 -- 25/10/2011 ******

# ----------------------------------------------------------------------------------------------- #

# ******
# count.s -- A program that expects a string of characters ending with a $ symbol and counts 
# the number of characters (excluding space (' ', 0x20) tab ('\t', 0x09) newline ('\n',0x0a)
# carriage-return ('\r', 0x0d) and the final $)
# ******

# ----------------------------------------------------------------------------------------------- #

# ****** Registers used:
#			$s0 -- to hold the current number of characters
#			$a0 -- to store various arguments for syscall
#			$v0 -- for syscall
# ******

# ----------------------------------------------------------------------------------------------- #

  .data
prompt1:	.asciiz		"Enter text, followed by $:\n"
# ****** "prompt1" is the prompt the user gets upon running the program. ******
prompt2:	.asciiz		"\nCount: "
# ****** "prompt2" is the prompt the user recieves at the end of the program. ******

  .globl main  
  .text
main:
  li $v0, 4		# Sets Register $v0 to 4 so that syscall knows to output a string
  la $a0, prompt1	# Make $a0 point to where the prompt is
  syscall		# Call the OS to print the prompt
  li $s0, 0		# Loads 0 into s0 as we will use s0 to count.  

loop:			# The start of a loop reading every character of the input string.
  li $v0, 12		# Sets Register $v0 to 12, so that syscall knows to read a character.
  syscall		# Call the OS to read the next character. $v0 now holds that character.
  beq $v0, '$', exit	# If the character is a $ sign then end loop and go to exit
  beq $v0, 0x20, loop	# If the character is a space we do not want to add 1 to the count, so we begin the loop again.
  beq $v0, 0x09, loop	# If the character is a tab we do not want to add 1 to the count, so we begin the loop again.
  beq $v0, 0x0a, loop	# If the character is a newline we do not want to add 1 to the count, so we begin the loop again.
  beq $v0, 0x0d, loop	# If the character is a carriage-return we do not want to add 1 to the count, so we begin the loop again.
  addi $s0, $s0, 1	# Adds 1 to the count in register $s0.
  j loop		# Returns to loop lable to analyse next character.

exit:			# When exiting the program, we want to print prompt2 and count, and then end the program
  la $a0, prompt2	# Make $a0 point to prompt2
  li $v0, 4		# Sets Register $v0 to 4 so that syscall knows to output a string
  syscall		# Call the OS to print prompt2
  add $a0, $s0, $zero	# Make $a0 point to $s0.
  li $v0, 1		# Sets Register $v0 to 1 so that syscall knows to output an integer
  syscall		# Call the OS to print the count
  li $a0, 10		# Sets the value of Register $a0 to 10, which corresponds to a new line.
  li $v0, 11		# Sets the value of Register $v0 to 11, so that syscall knows to output a character.
  syscall		# Prints a new line
  li $v0, 10		# Sets $v0 to 10 so that syscall knows to end the program
  syscall		# End the program

# ----------------------------------------------------------------------------------------------- #

# ****************************   ___________   ___ _____  ____ ____   *************************** #
# ****************************  / ___/      | /  _]     |/    |    \  *************************** #
# **************************** (   \_|      |/  [_|   __|  o  |  _  | *************************** #
# ****************************  \__  |_|  |_|    _]  |_ |     |  |  | *************************** #
# ****************************  /  \ | |  | |   [_|   _]|  _  |  |  | *************************** #
# ****************************  \    | |  | |     |  |  |  |  |  |  | *************************** #
# ****************************   \___| |__| |_____|__|  |__|__|__|__| *************************** #

# ----------------------------------------------------------------------------------------------- #
                                      


