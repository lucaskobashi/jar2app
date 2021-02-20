#!/bin/bash

# Shell script to create a .app file from a .jar
# FOR ADITIONAL FILES, MUST IMPORT MANUALLY TO .app/Contents/Java

echo "Please input the name of the .app (without the extension):"
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

# Creates directory structure

echo "Creating directory structure..."
BASE="$APPNAME.app/Contents"
mkdir -p "$BASE/Java" "$BASE/MacOS" "$BASE/Resources"

# # Input .icns file

echo "Please input the absolute path for the .icns file (leave blank if none):"
read ICNSPATH

if [[ -n $ICNSPATH ]]
then

    # Testing .icns string
    while [[ ! ${ICNSPATH: -5} == ".icns" ]]
    do
        echo "Error: invalid .icns file."
        echo "Please input the absolute path for the .icns file:"
        read ICNSPATH
    done

    # Testing if .icns is a valid file
    while [[ ! -f $ICNSPATH ]]
    do
        echo "Error: .jar file does not exist."
        echo "Please input the absolute path for the .jar file:"
        read ICNSPATH
    done

    echo "Copying .icns file"
    cp $ICNSPATH "$BASE/Resources/$APPNAME.icns"

else
    echo "No .icns file was determined by the user."
fi

# Downloading and managing universalJavaApplicationStub file

echo "Downloading universalJavaApplicationStub..."
curl https://github.com/tofi86/universalJavaApplicationStub/archive/master.zip -sLo universalJavaApplicationStub.zip
mkdir tempdirforjar2app
unzip -q universalJavaApplicationStub.zip -d tempdirforjar2app
mv tempdirforjar2app/universalJavaApplicationStub-master/src/universalJavaApplicationStub "$BASE/MacOS/universalJavaApplicationStub"
rm -rf universalJavaApplicationStub.zip tempdirforjar2app
echo "Download completed..."

echo "Parsing .jar file..."
MAINCLASS=$(unzip -qc $JARPATH META-INF/MANIFEST.MF | grep "Main-Class: *" | sed "s/Main-Class: //" | tr -d '[:space:]')

echo "Copying .jar file..."
JARBASE=$(basename $JARPATH)
cp $JARPATH "$BASE/Java/$JARBASE"

echo "Writing Info.plist..."
touch $BASE/Info.plist

echo "
<?xml version=1.0 encoding=UTF-8?>
<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=1.0>
    <dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>English</string>

    <key>CFBundleExecutable</key>
    <string>universalJavaApplicationStub</string>

    <key>CFBundleIconFile</key>
    <string>$APPNAME</string>

    <key>CFBundleIdentifier</key>
    <string>com.jar2app.example.$APPNAME</string>

    <key>CFBundleDisplayName</key>
    <string>$APPNAME</string>

    <key>CFBundleInfoDictionaryVersion</key>
    <string>8.0</string>

    <key>CFBundleName</key>
    <string>$APPNAME</string>

    <key>CFBundlePackageType</key>
    <string>APPL</string>

    <key>NSPrincipalClass</key>
    <string>NSApplication</string>

    <key>NSHighResolutionCapable</key>
    <string>True</string>

    <key>CFBundleShortVersionString</key>
    <string>1.0.1</string>

    <key>CFBundleSignature</key>
    <string>????</string>

    <key>CFBundleVersion</key>
    <string>1.0.1</string>

    <key>JVMMainClassName</key>
    <string>$MAINCLASS</string>

    <key>JVMOptions</key>
    <array>
        <string>-Duser.dir=\$APP_ROOT/Contents</string>
        <string>-Xdock:name=$APPNAME</string>
    </array>

    <key>JVMArguments</key>
    <array>
    </array>

    </dict>
</plist>
" > $BASE/Info.plist

echo "Completed..."
