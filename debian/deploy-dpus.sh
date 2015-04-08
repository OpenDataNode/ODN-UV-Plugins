#!/bin/bash

URL="http://127.0.0.1:18080/master/api/1/import/dpu/jar"
MASTER_USER=user
MASTER_PASS=pass

echo "---------------------------------------------------------------------"
echo "Installing DPUs.."
echo "..target instance: $URL"
echo "---------------------------------------------------------------------"

function install_dpu() {
    dpu_file=$(ls $1)

    echo -n "..installing $dpu_file: "
    outputfile="/tmp/$dpu_file.out"

    # fire cURL and wait until it finishes
    curl --user $MASTER_USER:$MASTER_PASS --fail --silent --output $outputfile -X POST -H "Cache-Control: no-cache" -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" -F file=@$dpu_file $URL?force=true &>/dev/null
    wait $!

    # check if the installation went well
    outcontents=`cat $outputfile`
    echo $outcontents
}

#############################################
#           filename of DPU JAR             #
#############################################
install_dpu "uv-l-catalog-*.jar"                
install_dpu "uv-l-filesToCkan-*.jar"            
install_dpu "uv-l-rdfToCkan-*.jar"              
install_dpu "uv-l-relationalToCkan-*.jar"       
install_dpu "uv-l-relationaldiffToCkan-*.jar"   
