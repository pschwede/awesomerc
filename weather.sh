#!/bin/bash

tmp=$(mktemp)
tar=/tmp/weather.tmp

curl -s -A "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20131026 Firefox/15.5" "http://isitraining.in/$1" -o $tmp
grep -Eo '[0-9]+&deg;C' $tmp | sed 's/&deg;/°/' > $tar

cond=$(grep -Eo ': <strong>.+</strong>' mktemp | sed 's/^: <.\+>\(.\+\)<\/.\+>$/\1/')

rm $tmp

if [[ $(echo $cond | grep -iE "partly|sun") ]]; then
  echo -e "\xE2\x98\x80" >> $tar;  # sun
elif [[ $(echo $cond | grep -iE "clear") ]]; then
  echo -e "\xE2\x9C\xA8" >> $tar;  # stars
elif [[ $(echo $cond | grep -iE "storm|thunder") ]]; then
  echo -e "\xE2\x98\x88" >> $tar;  # thunderstorm
elif [[ $(echo $cond | grep -iE "fair|cloudy|overcast") ]]; then
  echo -e "\xE2\x98\x81" >> $tar;  # cloud
elif [[ $(echo $cond | grep -iE "showers|drizzle|light") ]]; then
  echo -e "\xE2\x98\x82" >> $tar;  # umbrella
elif [[ $(echo $cond | grep -iE "heavy|rain") ]]; then
  echo -e "\xE2\x98\xB7" >> $tar;  # umbrella with drops
elif [[ $(echo $cond | grep -iE "mist|fog") ]]; then
  echo -e "\xE2\x98\xB7" >> $tar;  # trigram for earth
elif [[ $(echo $cond | grep -iE "freezing") ]]; then
  echo -e "\xE2\x9D\x84" >> $tar;  # snowflake
else
  echo $cond >> $tar;
fi

cat $tar
