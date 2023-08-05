#!/bin/bash
# Author: Jose Anton
# License: GPL3+
# for FILE in *{.cbr,.CBR,.Cbr}
# do
# [ -e "$FILE" ] || continue # Check if file exists or continue.
# echo Converting $FILE to cbz format.
# DIR="${FILE%.*}"
# mkdir "$DIR";
# "C:\Program Files\7-Zip\7z.exe" e ./"$FILE" -oc:"$DIR";
# "C:\Program Files\7-Zip\7z.exe" a "$DIR".zip "$DIR" -mx0;
# echo compression of $FILE successful!
# mv "$DIR".zip "$DIR".cbz
# echo extension renamed of $FILE successful!
# rm -rf "$DIR";
# #Remove or comment out this line if you want to keep cbr files
# rm "$FILE";
# echo Conversion of $FILE successful!
# done
for i in */; 
do 
"C:\Program Files\7-Zip\7z.exe" a "${i%/}.zip" "$i" -mx0;
echo compression of ${i%/} successful!
mv "${i%/}".zip "${i%/}".cbz
echo extension renamed of $FILE successful!
done