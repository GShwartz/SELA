#!/bin/bash

<<comment
	This is a feature build for password_validator.sh.
	The original script only checks for passwords comes from AD-HOC command.
	This feature is a solution for working with files and a decent summerization.
	
	The script breakes down to 6 main functions that checks if the string matches the requirements.
	1. Above 10 characters.
	2. Includes Digits [0-9]
	3. Includes Alpha [Aa-Zz]
	4. Includes Special [!@#$%^&*()_+=-]
	5. Includes Uppercase Letters [A-Z]
	6. Includes Lowercase Letters [a-z]
	
	Written by Gil Shwartz @2022

comment

show_help(){
	# Print Help Information
	echo "A Script to test if a string passes the requirements."
	echo "[A-Z] + [a-z] + [0-9] + [!@#$%^&*()+_:/.,] > 10 total characters."
	echo ""
	echo "-p 	password's text"
	echo "-f	password's file"
	echo ""
	echo "Usage: ./password-validator.sh [-p] [text] | [-f] [path/to/filename]"

	exit 0
}

function check_length() {
	# Return 0 if Pass and 1 if Failed.
	if [[ ${#1} -gt 10 ]]
	then
		echo "Length: $(tput setaf 2)PASS $(tput setaf 7)"
		return 0	
		
	else
		echo "Length: $(tput setaf 1)FAIL $(tput setaf 7)"
		return 1
		
	fi
}

function check_digits() {
	if [[ "$1" == *[[:digit:]]* ]]
	then
		echo "Digits: $(tput setaf 2)PASS $(tput setaf 7)"
		return 0

	else
		echo "Digits: $(tput setaf 1)FAIL $(tput setaf 7)"
		return 1

	fi
}

function check_alpha() {
	if [[ "$1" == *[[:alpha:]]* ]]
	then
		echo "Alphas: $(tput setaf 2)PASS $(tput setaf 7)"
		return 0

	else
		echo "Alphas: $(tput setaf 1)FAIL $(tput setaf 7)"
		return 1

	fi
}

function check_specials() {
	if [[ "$1" == *[[:punct:]]* ]]
	then
		echo "Special: $(tput setaf 2)PASS $(tput setaf 7)"
		return 0

	else
		echo "Special: $(tput setaf 1)FAIL $(tput setaf 7)"
		return 1

	fi

}

function check_upper() {
	if [[ "$1" =~ [A-Z] ]]
	then
		echo "Upper: $(tput setaf 2)PASS $(tput setaf 7)"
		return 0

	else
		echo "Upper: $(tput setaf 1)FAIL $(tput setaf 7)"
		return 1
		
	fi

}

function check_lower() {
	if [[ "$1" =~ [a-z] ]]
	then
		echo "Lower: $(tput setaf 2)PASS $(tput setaf 7)"
		return 0
		
	else
		echo "Lower: $(tput setaf 1)FAIL $(tput setaf 7)"
		return 1

	fi
}

function get_file() {
	<<comment
	1. Create a temporary Dictionary that will hold the requirement field and test result for each password.
	2. Check if the password meets each requirement. (Length, Digits, Alphas, Specials, Upper, Lower).
	3. Iterate through the temporary dictionary and filter out the failed | passed results.
	4. Distribute results to Fail | Pass lists.
	5. Update failed, passed and checked counters.
	6. Display summerization.
	
comment

	# Step 1
	declare -A tempDict
	
	# Step 2
	while read -r line
	do
		echo "====================="
		echo "Checking password: $line"
		
		check_length "$line"
		tempDict["length"]="$?"
		
		check_digits "$line"
		tempDict["digits"]="$?"
		
		check_alpha "$line"
		tempDict["alpha"]="$?"
		
		check_specials "$line"
		tempDict["specials"]="$?"
		
		check_upper "$line"
		tempDict["upper"]="$?"
		
		check_lower "$line"
		tempDict["lower"]="$?"	
		
		# Step 3: Iterate tempDict for Failed results
		for key in "${!tempDict[@]}"; do
			if [[ "${tempDict[$key]}" == "1" ]]
			then		
				if [[ ! ${fail[*]} =~ "$line" ]]
				then
					# Step 4: Distribute to Fail list
					fail+=("$line")
					
					# Step 5: Update failed counter
					let failed++
				
				else
					continue
				
				fi
			fi

		done
		
		# Step 3: Iterate tempDict for Failed results
		for key in "${!tempDict[@]}"; do
			if [[ "${tempDict[$key]}" == "0" ]] && [[ ${fail[*]} =~ "$line" ]] && [[ ! ${pass[*]} =~ "line" ]]
			then				
				continue
				
			elif [[ "${tempDict[$key]}" == "0" ]] && [[ ! ${fail[*]} =~ "$line" ]]
			then
				if [[ ! ${pass[*]} =~ "$line" ]]
				then
					#Step 4: Distribute to Pass list
					pass+=("$line")
					
					# Step 5: Update passed counter
					let passed++
				
				fi

			fi	
			
		done
		
		# Step 5: Update checked counter
		let counter++
		
	done < $1
	
	# Step 6: Print Summerization
	echo ""
	echo "Total checked: $counter"
	echo "Total passed: $passed"
	echo "$(tput setaf 2)${pass[*]} $(tput setaf 7)"
	echo "Total failed: $failed"
	echo "$(tput setaf 1)${fail[*]} $(tput setaf 7)"
	echo ""
			
}

function get_text() {
	<<comment
	1. Check if the password meets each requirement. (Length, Digits, Alphas, Specials, Upper, Lower).
	2. Display summerization.
	
comment
	
	check_length "$1"
	check_digits "$1"
	check_alpha "$1"
	check_specials "$1"
	check_upper "$1"
	check_lower "$1"

}

# Initialize counters
counter=0
passed=0
failed=0

# Create lists & dicts
declare -a pass
declare -a fail
declare -A dict

# Wait & Respond to AD-HOC Command	
while getopts 'hfp' option
do
	case $option in
	h)
	# The user asked for the help information.
	show_help
	;;

	f)
	# The user chose to work from a file.
	get_file "$2"
	;;

	p)
	# The user chose to work with an AD-HOC password.
	get_text "$2"
	;;

	*)
	# The user entered the wrong information.
	echo "Bad arguments"
	exit 1
	;;

	esac	

done




