#!/bin/bash

nameset=false
debug=false
loop=false
del=false
flagged=true
dat="list.dat"
ernum=0

loopcheck() {
if $loop; then
  prompset=false
  promptcount=0
  prompt
  run
 else
  delfil $ernum
 fi
}

helpme() {
 echo -e "[HELP]\n-s Set student name.\n-f Override file to load in.\n-d Turn on debug mode.\n-l To loop through prompt.\n-p Print out list file.\n-r Delete all unneeded files (including the hidden one).\n[----]";
}

debugmode() {
 if $debug; then echo "$@"; fi
}

delfil() {
 if $del; then
  if test -f ".ransearchbefore-avery"; then rm .ransearchbefore-avery; fi
 fi
 if test -f "sortedlist.dat"; then rm sortedlist.dat; fi
 exit $1
}

while getopts 's:f:dhlrp' flag; do
 case "${flag}" in
  s) n="${OPTARG}"; nameset=true ;;
  f) dat="${OPTARG}"; echo "[OVERRIDE] Loading in $dat." ;;
  d) debug=true; echo "[OVERRIDE] Activated debug mode." ;;
  h) helpme; delfil ;;
  l) loop=true; echo "[LOOP] (press enter a few times to exit)" ;;
  r) del=true; delfil ;;
  p) echo [FILE] - $dat - SOF; cat $dat; echo [FILE] - $dat - EOF ;;
  *) echo "Unexpected option ${flag}"; helpme; flagged=false ;;
 esac
done

if test ! -f ".ransearchbefore-avery"; then
 echo "Welcome First Time User."
 if $flagged; then helpme; fi
fi 


sort $dat > sortedlist.dat
cat sortedlist.dat > .ransearchbefore-avery

promptcount=0;

prompt() {
 if [ $promptcount -gt 2 ]; then echo "[ERROR] To many tries without input. Exiting."; loop=false; loopcheck; fi 
 read -p "Name: " n;
 if [[ -z "$n" ]]; then echo "[ERROR] No name inputed."; ((promptcount++)); prompt; fi
}

n=${n,,}

binsearch() { 
    local firstnum=$1
    local lastnum=$2
    
    # middle is half between
    middle=$((firstnum + $(($(($lastnum - $firstnum)) /2 )) ))
    
    debugmode [DEBUG] firstnum=$firstnum lastnum=$lastnum  middle=$middle;
    debugmode [DEBUG] ${lcname[$middle]};
    
    # check if n matches there
    if [ "${lcname[$middle]}" = "$n" ]; then
     echo "${name[$middle]}'s grade is ${grade[$middle]}."
     loopcheck
    elif [ $lastnum = $middle  -o $firstnum = $middle ]; then
     echo "${n} is not in the list."
     ernum=1
     loopcheck
    elif [[ "$n" > "${lcname[$middle]}" ]]; then
      firstnum=$middle
    elif [[ "$n" < "${lcname[$middle]}" ]]; then
     lastnum=$middle
    fi
    binsearch $firstnum $lastnum
    
}

count=1
while read line ; do
 name[$count]="${line%%:*}"
 lcname[$count]=${name[$count],,}
 grade[$count]="${line##*:}"
 debugmode [DEBUG] 'name['$count']'=${name[$count]} lcname=${lcname[$count]};
 ((count++))
done < sortedlist.dat

total=$count
num=1;

case $nameset in
 (false) prompt;
esac

run() {
 binsearch 1 $total
}

run

if []
#large comment block :)
#List for list.dat

Hal:B
Frank:C
Bob:C
Justin:F
Cindy:B
Emily:A
Ginger:D
Ann:A
Ivy:A
Karen:D
Dean:F

fi


