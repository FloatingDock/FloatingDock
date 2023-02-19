#!/bin/sh

SRCROOT=$1

echo "------- SRCROOT IS:"
echo $SRCROOT

# Customizable variables
# find with `security find-identity -p basic -v`
PRODUCT_NAME=FloatingDock
CODE_SIGN_ENTITLEMENTS=$SRCROOT/$PRODUCT_NAME/$PRODUCT_NAME.entitlements
SIGN_IDENTITY="2A7EE948E3C71493C8CA7B9E2D8EC7640778109A"

# Set app and zip path
EXPORT_PATH=$SRCROOT/Archive
APP_PATH="$EXPORT_PATH/$PRODUCT_NAME.app"
ZIP_PATH="$EXPORT_PATH/$PRODUCT_NAME.zip"

# Re-sign bundle
codesign \
    --deep \
    --force \
    --options=runtime \
    --entitlements $CODE_SIGN_ENTITLEMENTS \
    --sign $SIGN_IDENTITY \
    --timestamp "$APP_PATH"

# Notarize the app
xcnotary notarize $APP_PATH \
  --developer-account thomas@meandmymac.de \
  --developer-password-keychain-item macos-notarization

# Create a ZIP archive suitable for notarization.
/usr/bin/ditto -c -k --keepParent "$APP_PATH" "$ZIP_PATH"

# Sign Sparkle update
sparkle_sign_update "$ZIP_PATH" > "$EXPORT_PATH/sparkle-signature.txt"

# As a convenience, open the export folder in Finder.
#/usr/bin/open "$EXPORT_PATH"
