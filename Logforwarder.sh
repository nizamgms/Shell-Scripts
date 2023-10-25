
#fetching and storing logs in a file
MODULE_NAME=$(oc get pods |grep ${PodName} |grep -v deploy |awk '{print $1}')
echo $MODULE_NAME
TIMESTAMP=$(date | awk '{print $2, $3, $4, $6}' | tr ' ' '-')
echo $TIMESTAMP
touch ${MODULE_NAME}-${TIMESTAMP}.csv
timeout 15s oc logs -f $MODULE_NAME >> ${MODULE_NAME}-${TIMESTAMP}.csv


# about the file
file_to_upload=${MODULE_NAME}-${TIMESTAMP}.csv
bucket=<your s3 bucket name>
filepath="/${bucket}/${file_to_upload}"

# metadata
contentType="application/x-compressed-tar"
dateValue=`date -R`
signature_string="PUT\n\n${contentType}\n${dateValue}\n${filepath}"

#s3 keys
s3_access_key=<your s3 access key>
s3_secret_key=<your s3 secret key>

#prepare signature hash to be sent in Authorization header
signature_hash=`echo -en ${signature_string} | openssl sha1 -hmac ${s3_secret_key} -binary | base64`


=======================================================================================================


s3cmd put eproc-module-name.csv s3://BUCKET[/PREFIX]


