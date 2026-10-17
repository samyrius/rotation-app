#!/usr/bin/env bash
set -euo pipefail
cd "${CODESPACE_VSCODE_FOLDER:-/workspaces/ResiManage}"
if [ -f /tmp/resimanage-demo.pid ] && kill -0 "$(cat /tmp/resimanage-demo.pid)" 2>/dev/null; then
  exit 0
fi
nohup python -c "import app; app.init(); app.app.run(host='0.0.0.0', port=5000, debug=False, use_reloader=False)" >/tmp/resimanage-demo.log 2>&1 &
echo $! >/tmp/resimanage-demo.pid
