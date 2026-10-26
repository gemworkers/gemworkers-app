#!/usr/bin/env bash
# Build + deploy the admin (sell.gemworkers.com). Bakes a build id into the app
# and writes the same id to build.json, so open tabs offer "Reload" when a newer
# version is live (lib/widgets/update_notice.dart).
set -euo pipefail
cd "$(dirname "$0")"
ID=$(date -u +%Y%m%d%H%M%S)
/c/Users/Zakaria/Desktop/Flutter/flutter/bin/flutter.bat build web --dart-define=BUILD_ID="$ID"
printf '{"id":"%s"}\n' "$ID" > build/web/build.json
cd build/web && npx vercel --prod --yes
