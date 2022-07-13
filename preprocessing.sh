enableTexCompress=$1
quality=$2

# echo "quality:${quality}"
buildToolDir=$(cd "$(dirname "$0")";pwd)
rootDir=`pwd`

if [ $enableTexCompress == 1 ]
then
    echo "texcompres time1:"$(date "+%s")
    res=$(find -E . -regex ".*\.(pac|jpg|png)\.meta")
    echo "texcompres time2:"$(date "+%s")
    metaPaths=""
    OLDIFS="$IFS"
    IFS=$'\n'
    for element in ${res}
    do
        if [ "$metaPaths" == "" ]
        then
            metaPaths=$element
        else
            metaPaths=${metaPaths}","$element
        fi
    done
    IFS="$OLDIFS"
    # echo "metaPaths:${metaPaths}"
    echo "texcompres time3:"$(date "+%s")
    node ${buildToolDir}/dealPicMeta.js ${quality} "${metaPaths}"
    echo "texcompres time4:"$(date "+%s")
fi
