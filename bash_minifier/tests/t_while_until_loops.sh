echo "while"

counter=0

while

[ "$counter" -lt 10 ]

do


        echo $counter


        counter=$((counter+2))

done

echo "until"


counter=8

until

[ "$counter" -lt 0 ]

do


        echo $counter


        counter=$((counter-2))

done