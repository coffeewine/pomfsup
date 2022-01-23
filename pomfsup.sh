#!/bin/sh

#license: MIT

#another pomf uploader
##no multiple files support
##no upload via url support

host="$1"
localFile="$2"

if [ "$#" -lt 2 ] || [ "$#" -gt 2 ]; then

echo "
Pomf file uploader
Usage: ./$(basename "$0") alias File

Supported sites:
  * pomf.cat             [75 MiB]       (alias: pomfcat)
  * uguu.se              [128 MiB 48h]  (alias: uguu)
  * catbox.moe           [200 MiB]      (alias: catbox)
  * 0x0.st               [512 MiB]      (alias: 0x0)
  * litterbox.catbox.moe [1 GB 72h]     (alias: litter)
  * zz.ht                [1024 MiB]     (alias: zzht)
  * cockfile.com         [2048 MiB 24h] (alias: cock)
  * temp.sh              [4 GB 72h]     (alias: litter)
"
exit
fi

case "$host" in
    pomfcat) hostURL='https://pomf.cat/upload.php' ;;
    uguu) hostURL='https://uguu.se/upload.php' ;;
    0x0) hostURL='https://0x0.st' ;;
    catbox) hostURL='https://catbox.moe/user/api.php' ;;
    zzht) hostURL='https://zz.ht/api/upload' ;;
    cock) hostURL='https://cockfile.com/upload.php' ;;
    temp) hostURL='https://temp.sh' ;;
    litter) hostURL='https://litterbox.catbox.moe/resources/internals/api.php' ;;

esac

if [ "$host" = 'uguu' ]; then
    uploadResult="$(curl -sf -F file="@$localFile" "$hostURL")"

elif [ "$host" = 'pomfcat' ]; then
    uploadResult="$(curl -sf -F files[]=@"$localFile" "$hostURL" | jq -r .files[].url)"

elif [ "$host" = '0x0' ]; then
	uploadResult="$(curl -sf -F file="@$localFile" "$hostURL")"

elif [ "$host" = 'catbox' ]; then
    uploadResult="$(curl -sf -F reqtype="fileupload" -F userhash="" -F fileToUpload="@$localFile" "$hostURL")"

elif [ "$host" = 'zzht' ]; then
    uploadResult="$(curl -sf -F DestinationType="FileUploader" -F files[]=@"$localFile" "$hostURL" | jq -r .files[].url)"

elif [ "$host" = 'cock' ]; then
    uploadResult="$(curl -sf -F files[]=@"$localFile" "$hostURL" | egrep -o "a.cockfile.com[a-z0-9A-Z./\]{1,20}" | sed 's/\\//')"

elif [ "$host" = 'temp' ]; then
    uploadResult="$(curl -sf -T "$localFile" "$hostURL")"

elif [ "$host" = 'litter' ]; then
    uploadResult="$(curl -sf -F "reqtype=fileupload" -F "time=72h" -F fileToUpload="@$localFile" "$hostURL")"

else
    echo "something went wrong"
fi

echo "$uploadResult"
