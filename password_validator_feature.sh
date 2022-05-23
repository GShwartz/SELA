#!/bin/bash


# Print Help Information
show_help(){
	echo "A Script to test if a string passes the requirements."
	echo "[A-Z] + [a-z] + [0-9] + [!@#$%^&*()+_:/.,] > 10 total characters."
	echo ""
	echo "-p 	password's text"
	echo "-f	password's file"
	echo ""
	echo "Usage: ./script [-p] [text] | [-f] [path/to/filename]"

	exit 0
}

# Inspect file
validate() {
	passed=0
	failed=0
	counter=0
	declare -a pass
	declare -a fail
	
	while read -r line
	do
		echo "================="
		echo "checking password: $line"

		# Validate number of charecters is grater than 10
		if [[ ${#line} -gt 10 ]]
		then
			echo "Length: $(tput setaf 2)PASS $(tput setaf 7)"

			# Check if the string contains digits
			if [[ $line == *[[:digit:]]* ]]
			then
				echo "Digits: $(tput setaf 2)PASS $(tput setaf 7)"

				# Check if the string contains alphas
				if [[ $line == *[[:alpha:]]* ]]
				then
					echo "Alpha: $(tput setaf 2)PASS $(tput setaf 7)"
					
					# Check if the string contains special chars
					if [[ "$line" == *[[:punct:]]* ]]
					then
						echo "Special: $(tput setaf 2)PASS $(tput setaf 7)"
						
						# Check if string contains Uppercase letters
						if [[ $line =~ [A-Z] ]]
						then
							echo "Uppercase: $(tput setaf 2)PASS $(tput setaf 7)"
							
							# Check if the string contains Lowercase letters
							if [[ $line =~ [a-z] ]]
							then
								echo "Lowercase: $(tput setaf 2)PASS $(tput setaf 7)"
								
								# Update counter
								let passed++
								let counter++
								
								# Update passed list
								pass+=("$line")

							# Print Lowercase error
							else
								echo "Lowercase: $(tput setaf 1)FAIL $(tput setaf 7)"
								echo "============"

								# Update counters
								let failed++
								let counter++
								
								# Update failed list
								fail+=("$line")

							fi
						
						# Print Uppercase error
						else
							echo "Uppercase: $(tput setaf 1)FAIL $(tput setaf 7)"
							
							# Update counters
							let failed++
							let counter++
							
							# Update failed list
							fail+=("$line")
						fi
					
					# Print Special Chars error
					else
						echo "Special: $(tput setaf 1)FAIL $(tput setaf 7)"
						
						# Update counters
						let failed++
						let counter++
						
						# Update fail list
						fail+=("$line")
					fi
				
				# Print Alphas error
				else
					echo "Alpha: $(tput setaf 1)FAIL $(tput setaf 7)"
					
					# Update counters
					let failed++
					let counter++
					
					# Update failed list
					fail+=("$line")
				fi

			# Print Digits error
			else
				echo "Digits: $(tput setaf 1)FAIL $(tput setaf 7)"
				
				# Update counters
				let failed++
				let counter++
				
				# Update failed list
				fail+=("$line")
			fi

		# Print Length error
		else
			echo "Length: $(tput setaf 1)FAIL $(tput setaf 7)"

			# Update counters
			let failed++
			let counter++
			
			# Update failed list
			fail+=("$line")

		fi

	# end loop if there's no lines left
	done < $1
	
	# Print Summerization
	echo ""
	echo "Total checked: $counter"
	echo "Total passed: $passed"
	echo "$(tput setaf 2)${pass[*]} $(tput setaf 7)"
	echo ""
	echo "Total failed: $failed"
	echo "$(tput setaf 1)${fail[*]} $(tput setaf 7)"
	echo ""

}

# Inspect AD-HOC argument
val() {
	if [[ ${#1} -gt 10 ]]
	then
		echo "Length: $(tput setaf 2)PASS $(tput setaf 7)"

		if [[ "$1" == *[[:digit:]]* ]]
		then
			echo "Digits: $(tput setaf 2)PASS $(tput setaf 7)"
			
			if [[ "$1" == *[[:alpha:]]* ]]
			then
				echo "Alphas: $(tput setaf 2)PASS $(tput setaf 7)"
				
				if [[ "$1" == *[[:punct:]]* ]]
				then
					echo "Special: $(tput setaf 2)PASS $(tput setaf 7)"
					
					if [[ "$1" =~ [A-Z] ]]
					then
						echo "Upper: $(tput setaf 2)PASS $(tput setaf 7)"
						
						if [[ "$1" =~ [a-z] ]]
						then
							echo "Lower: $(tput setaf 2)PASS $(tput setaf 7)"

							# Exit script with code 0
							exit 0

						else
							echo "Lower: $(tput setaf 1)FAIL $(tput setaf 7)"

							# Exit script with code 1
							exit 1
						fi

					else
						echo "Upper: $(tput setaf 1)FAIL $(tput setaf 7)"
						exit 1
					fi

				else
					echo "Special: $(tput setaf 1)FAIL $(tput setaf 7)"
					exit 1
				fi

			else
				echo "Alphas: $(tput setaf 1)FAIL $(tput setaf 7)"
				exit 1
			fi
		
		else
			echo "Digits: $(tput setaf 1)FAIL $(tput setaf 7)"
			exit 1
		fi
	
	else
		echo "Length: $(tput setaf 1)FAIL $(tput setaf 7)"
		exit 1
	fi
	
}


while getopts 'hfp' option
do
	case $option in
	h)
	show_help
	;;

	f)
	validate "$2"
	;;

	p)
	val "$2"
	;;

	*)
	echo "Bad arguments"
	exit 1

	esac
done


