osascript -e 'tell application "Terminal" to do script "kubectl -n services-testing port-forward postgres-master-0 5432:5432"';
osascript -e 'tell application "Terminal" to do script "kubectl -n services-testing port-forward redis-master-0 6379:6379"';

# Get the path to the script directory
SCRIPT_DIR="$(dirname "$0")"
cd ${SCRIPT_DIR}/../gateway
DEUBG=* yarn dev
