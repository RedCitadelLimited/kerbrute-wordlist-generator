while read name; do
  for l in {a..z}; do
    echo "$l.$name"
    echo "$name.$l"
    echo "$l$name"
    echo "$name$l"
  done
done < surnames.txt > usernames.txt
