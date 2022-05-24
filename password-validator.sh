#!/bin/bash


# Validate number of charecters is grater than 10
if [[ ${#1} -gt 10 ]]
then
	set +H
	echo "Length: $(tput setaf 2)PASS $(tput setaf 7)"

	# Check if the string contains digits
	if [[ "$1" == *[[:digit:]]* ]]
	then
		echo "Digits: $(tput setaf 2)PASS $(tput setaf 7)"

		# Check if the string contains alphas
		if [[ "$1" == *[[:alpha:]]* ]]
		then
			echo "Alpha: $(tput setaf 2)PASS $(tput setaf 7)"
			
			# Check if the string contains special chars
			if [[ $1 == *[[:punct:]]* ]]
			then
				echo "Special: $(tput setaf 2)PASS $(tput setaf 7)"
				
				# Check if string contains Uppercase letters
				if [[ "$1" =~ [A-Z] ]]
				then
					echo "Uppercase: $(tput setaf 2)PASS $(tput setaf 7)"
					
					# Check if the string contains Lowercase letters
					if [[ "$1" =~ [a-z] ]]
					then
						echo "Lowercase: $(tput setaf 2)PASS $(tput setaf 7)"

						# Exit script with code 0
						exit 0
					
					# Print Lowercase error & Exit script with code 1
					else
						echo "Lowercase: $(tput setaf 1)FAIL $(tput setaf 7)"
						
						# Exit script with code 1
						exit 1
						
					fi
				
				# Print Uppercase error & Exit script with code 1
				else
					echo "Uppercase: $(tput setaf 1)FAIL $(tput setaf 7)"
					
					# Exit script with code 1
					exit 1
					
				fi
			
			# Print Special Chars error & Exit script with code 1
			else
				echo "Special: $(tput setaf 1)FAIL $(tput setaf 7)"
				
				# Exit script with code 1
				exit 1
				
			fi
		
		# Print Alphas error & Exit script with code 1
		else
			echo "Alpha: $(tput setaf 1)FAIL $(tput setaf 7)"
			
			# Exit script with code 1
			exit 1
			
		fi

	
	# Print Digits error & Exit script with code 1
	else
		echo "Digits: $(tput setaf 1)FAIL $(tput setaf 7)"
		
		# Exit script with code 1
		exit 1
		
	fi

# Print Length error & Exit script with code 1
else
	echo "Length: $(tput setaf 1)FAIL $(tput setaf 7)"
	
	# Exit script with code 1
	exit 1	
fi
