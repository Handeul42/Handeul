#!/bin/sh

echo "Generating GoogleService-Info.plist from template..."
cat GoogleService-Info.plist.template | envsubst > ../kWordle/GoogleService-Info.plist

