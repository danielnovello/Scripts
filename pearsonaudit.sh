me=$(whoami); hostname > ~/Desktop/"$me".txt; 
printf '%60s\n' | tr ' ' - >> ~/Desktop/"$me".txt;
system_profiler SPHardwareDataType  >> ~/Desktop/"$me".txt;
mail -s "Pearson Audit $me" daniel.novello@pearson.com < ~/Desktop/$me.txt;
rm ~/Desktop/$me.txt
