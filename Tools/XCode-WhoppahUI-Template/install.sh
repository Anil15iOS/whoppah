USER_NAME=$USER
TEMPLATE_DIR="/Users/$USER_NAME/Library/Developer/Xcode/Templates/File Templates/Whoppah Templates/"

mkdir -p "$TEMPLATE_DIR"
cp -R WhoppahUI.xctemplate "$TEMPLATE_DIR"

echo "Copied template files to: $TEMPLATE_DIR"