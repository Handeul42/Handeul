#!/bin/bash

if [ -z "$GOOGLESERVICE_INFO_PLIST" ]; then
  echo "Error: Environment variable GOOGLESERVICE_INFO_PLIST is not set."
  exit 1
fi

cat > GoogleService-Info.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  $GOOGLESERVICE_INFO_PLIST
</dict>
</plist>
EOF

mv GoogleService-Info.plist ../kWordle/GoogleService-Info.plist 
