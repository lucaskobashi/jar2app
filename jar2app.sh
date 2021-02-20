#!/bin/bash

# Shell script to create a .app file from a .jar

echo "Please input the name of the .app:"
read APPNAME

# Testing the length of the .app string
while [[ ! -n $APPNAME ]]
do
    echo "Error: invalid name."
    echo "Please input the name of the .app:"
    read APPNAME
done

echo "Please input the absolute path for the .jar file:"
read JARPATH

# Testing .jar string
while [[ ! ${JARPATH: -4} == ".jar" ]]
do
    echo "Error: invalid .jar file."
    echo "Please input the absolute path for the .jar file:"
    read JARPATH
done

# Testing if .jar is a valid file
while [[ ! -f $JARPATH ]]
do
    echo "Error: .jar file does not exist."
    echo "Please input the absolute path for the .jar file:"
    read JARPATH
done

# Downloading and managing base file

echo "Downloading universalJavaApplicationStub..."
curl https://github.com/tofi86/universalJavaApplicationStub/archive/master.zip -sLo universalJavaApplicationStub.zip
mkdir tempdirforjar2app
unzip tempdirforjar2app/universalJavaApplicationStub.zip -d tempdirforjar2app

echo "Completed..."
