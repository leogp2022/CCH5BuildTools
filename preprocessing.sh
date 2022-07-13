enableTexCompress=$1
quality=$2
projectName=$3

# echo "quality:${quality}"
buildToolDir=$(cd "$(dirname "$0")";pwd)
rootDir=`pwd`

projectDir=${rootDir}
if [ "$projectName" != "" ]
then
    projectDir=${projectDir}/${projectName}
fi

function join_by { local IFS="$1"; shift; echo "$*"; }

if [ $enableTexCompress == 1 ]
then
    buildDir=${projectDir}/build
    wwwDir=${buildDir}/web-mobile
    rm -rf ${wwwDir}
    echo "texcompress time1:"$(date "+%s")
    res=$(find -E $projectDir -regex ".*\.(pac|jpg|png)\.meta")
    OLDIFS="$IFS"
    IFS=$'\n'
    metaPaths=$(join_by , $res)
    IFS="$OLDIFS"
    # echo "metaPaths:${metaPaths}"
    node ${buildToolDir}/dealPicMeta.js ${quality} "${metaPaths}"
    echo "texcompress time2:"$(date "+%s")
fi
