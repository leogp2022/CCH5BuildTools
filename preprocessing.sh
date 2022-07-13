quality=$1

# echo "quality:${quality}"
buildToolDir=$(cd "$(dirname "$0")";pwd)
rootDir=`pwd`

function join_by { local IFS="$1"; shift; echo "$*"; }

res=$(find -E . -regex ".*\.(pac|jpg|png)\.meta")
metaPaths=$(join_by , ${res})
# echo "metaPaths:${metaPaths}"
node ${buildToolDir}/dealPicMeta.js ${quality} ${metaPaths}
