#!/bin/bash
# Andrew Heller-Jones
# Intro to Unix Project 3 
# Mproj3scriptodified to take no parameters & simply perform the operation on ~ 
# 4/30/2021  

# The traverse funct descends down a file system tree
# in a pre order fashion. 
# I think the function should assume that the script is already
# within the ROOT_DIR
#@param $1 -- ROOT_DIR - the name of the root directory
#@param $2 -- TAB_NUM - the number of tabs to apply
#@param $3 -- RELATIVE_OUTPUT - the relative path to the output file
traverse() { 
	local ROOT_DIR=$1
	local TAB_NUM=$2
	local RELATIVE_OUTPUT=$3
	local TABS=""	
	# Each list has to begin with <ul>
	# Thus here we generate an initial tab
	for ((i = 0; i < $TAB_NUM; i++)); do 
		TABS+="\t"	
	done
	TABS+="\t"  # Add a tab since were now printing the directories
	local TABS_old=$TABS
	# If we're in an empty directory 
	if [[ `ls | wc -l` -eq 0 ]]; then 
		echo -e "$TABS<li>${PWD##*/}</li>" >> $RELATIVE_OUTPUT
	else
		echo -e "$TABS<li>${PWD##*/}" >> $RELATIVE_OUTPUT
		echo -e "$TABS<ul>" >> $RELATIVE_OUTPUT
		TABS+="\t"  # Add a tab since were now printing the directories
		# Get all the files in this dir
		for file in `ls -A`; do
			if [[ -r $file ]]; then 
					if [[  -d $file  ]]; then 
						cd $file	
						traverse "$file" $(($TAB_NUM+1)) "../$RELATIVE_OUTPUT"
						cd ..
						# Move tabs back one
						TABS=`echo $TABS | sed 's/\(.*\)\\t$/\(\1\)/'`
					else
						echo -e "$TABS<li>$file</li>" >> $RELATIVE_OUTPUT
					fi
			fi
		done
		TABS=`echo $TABS | sed 's/\(.*\)\\t\\t$/\(\1\)/'`
		echo -e "$TABS</li>" >> $RELATIVE_OUTPUT		
		TABS=`echo $TABS | sed 's/\(.*\)\\t$/\(\1\)/'`
		echo -e "$TABS</ul>" >> $RELATIVE_OUTPUT		
	fi 
}
	# main
	OUTPUT_PATH="$PWD"
	OG_ROOT_DIR="$HOME"
	OUTPUT_FILE="filetree.html"
	echo -e "<!DOCTYPE html>\n<html>\n<body>\n\n " > $OG_ROOT_DIR/$OUTPUT_FILE

	echo -e "<h1>Some directories from your computer</h1>\n" >> $OG_ROOT_DIR/$OUTPUT_FILE 
	cd 
	echo -e "<ul>" >> $OUTPUT_FILE
	traverse $OG_ROOT_DIR 0 $OUTPUT_FILE
	echo -e "</ul>" >> $OUTPUT_FILE
	mv $OUTPUT_FILE $OUTPUT_PATH



