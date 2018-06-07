function curlGetBodyAndCode (){



# store the whole response with the status at the and
HTTP_RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" -F file=@$2 -X POST -H 'Accept: text/turtle' $1)

# echo "$HTTP_RESPONSE"

# extract the body
HTTP_BODY=$(echo "$HTTP_RESPONSE" | sed -e 's/HTTPSTATUS\:.*//g')

# extract the status
HTTP_STATUS=$(echo "$HTTP_RESPONSE" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

# print the body

# example using the status
if [ ! $HTTP_STATUS -eq 200  ]; then
  echo -e "Endpoint: $1\nError HTTP Code: $HTTP_STATUS"

else

newfilename="$filename"_modified.ttl

  echo -e "Endpoint: $1\nCreated new file: $newfilename"
  echo "$HTTP_BODY">"$newfilename"
goodresponse=true
fi
}


if [ "$1" == "h" ]
then
  echo Prefix resolver v. 1.0
  echo "########################"
  echo Input
  echo ./script.sh example.ttl
  echo "########################"
  echo Output
  echo Saved Turtle file with name example_modified.ttl
  exit -1
fi

filename=`basename $1 .ttl`

result2=$(grep -v -i '@prefix_endpoint' $1)

tmpfile=$(mktemp)

echo "$result2">"$tmpfile"





# echo "$result2"

result=($(grep -i -o -P '(?<=@prefix_endpoint <).*(?=>)' $1))

for i in "${result[@]}"
do

if [ "$goodresponse" = true ] ; then
    exit 1;
fi

   curlGetBodyAndCode $i $tmpfile
done


rm "$tmpfile"



