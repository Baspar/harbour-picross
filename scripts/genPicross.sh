#!/bin/bash
FILE="../qml/Levels.js"


echo -n "Title: "
read title

echo -n "HintTitle: "
read hintTitle

echo -n "Dimension: "
read dimension

dim=$(echo $dimension | sed 's/[^0-9]*//g')

if [[ $dim == "" ]]
then
    echo "\"$dimension\" does not contains any number"
    exit 2
fi

if [ $dim -gt 20 ] || [ $dim -lt 3 ]
then
    echo "Please enter a dimension between 3 and 20 (included)"
    exit 1
fi

#####################
# Init final string #
#####################
out="
    {\n
           title: \"$title\",\n
           hintTitle: \"$hintTitle\",\n
           dimension: $dim,\n
           grid:\n
           [\n"

echo "Everything is fine, please enter the map"
for i in $(seq 1 $dim)
do
    # Read line ( Re-read if size != dimension or if it contains other characters than 0 or 1)
    read line
    while [ $(echo $line | wc -c) -ne $((dim+1)) ]||[ $(echo $line | sed 's/[01]//g' | wc -c) -ne 1 ]
    do
        if [ $(echo $line | sed 's/[01]//g' | wc -c) -ne 1 ]
        then
            echo 'Your line can only have 2 characters : 0(void) or 1(full)'
        else
            echo "Wrong line size ($(echo $line | head -c -1| wc -c)), you must enter a line whose size is $dim"
        fi
        read line
    done

    # We add comma between every number
    line=$(echo $line | sed 's/\(.\)/\1, /g' | head -c -2)

    # If last line, remove last comma
    if [ $i -eq $dim ]
    then
        line=$(echo $line | head -c -2)
    fi

    # Line added to out
    out+="                $line\n"
done

# Line closed
out+="            ]\n        }"


# Read difficulty
echo -n "Difficulty [0=Tutorial, 1=Easy, 2=Medium, 3=Hard, 4=Expert]: "
read difficulty
diff=$(echo $difficulty| sed 's/[^0-9]*//g')
if [[ $diff == "" ]]
then
    echo "\"$difficulty\" does not contains any number"
    exit 2
fi
if [ $diff -gt 4 ] || [ $diff -lt 0 ]
then
    echo "Please enter a number between 0 and 4 (included)"
    exit 1
fi

# Adding comment to find in the file
out+="\n    ]//END$diff"

out=$(echo "$out"| sed "s/\ /\\\ /g; s/\n/\\n/g")

# Get line number where to add a comma next to the }
lineNumber=$(cat $FILE | grep -n "}$" | cut -d ':' -f 1 | head -n $(($diff+1)) | tail -n 1 | head -c -1)

cp $FILE $(echo $FILE).old
cat $FILE | sed "$(echo $lineNumber)s/}/},/; s|\]//END$diff|$(echo $out)|g"> $FILE
#echo "$out"
