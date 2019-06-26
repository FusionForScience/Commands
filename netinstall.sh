#!/bin/bash
# Created by: Matthew Fan, Leonid Krashanoff
# Email: fanma@ucla.edu, krashanoff@ucla.edu
#
# The netinstall script allows for quick and easy
# installation of tykaneshige/Commands. Run with
# `curl -s netinstall.sh | /bin/bash 'DIRECTORY'`


# check that curl is installed
if [ -z "$(command -v curl)" ]
then
	echo "This install script requires curl to run."
done

# set up temporary local copy for installation
oldDir="$(pwd)"
tempDir="$(mktemp -d)"
cd tempDir
git clone git@github.com:tykaneshige/Commands.git
chmod -R u+x .


if [ $# = 1 ]
then
    installPath="$1"
elif [ $# -gt 1 ]
then
    echo "Please specify only one path"
    exit
else
    installPath="/usr/bin"
fi


echo "Possible overwrites: "
./overwrite-check.sh "$installPath"


echo "Okay to install to $installPath? [y , n]"


while [ true ]
do
    read response

    if [ "$response" = "n" ] || [ "$response" = "N" ]
    then
        exit
    elif [ "$response" != "y" ] && [ "$response" != "Y" ]
    then
        echo "Please enter either y or n"
    else
        break
    fi
done

echo
echo "Installing..."

commands=$(find ./commands -type f -executable)

echo
echo "$commands"

i=0
lines=$(echo "$commands" | wc -l)
while [ $i -lt $lines ]
do
    currentTailAmount=$(echo "$lines - $i" | bc)
    currentCommand="$(echo "$commands" | tail -n $currentTailAmount | head -n 1)"
    
    cp "$currentCommand" "$installPath"

    i=$(echo $i + 1 | bc)
done

# export to path, clean up
echo "export PATH=$PATH:"$installPath"" > ~/.bashrc
cd "$oldDir"
rm -r "$tempdir"