$/bin/bash

file1=$1
file2=$2
file3=$3

echo -n "--------------------------
User Name: Lee JungYeon
Student Number: 12223785
[ MENU ]
1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item’
3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’
4. Delete the ‘IMDb URL’ from ‘u.item
5. Get the data about users from 'u.user’
6. Modify the format of 'release date' in 'u.item’
7. Get the data of movies rated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit
---------------------------
"
while true; do
read -p "Enter your choice [ 1-9 ]" choiceNum

case $choiceNum in
1)
echo -e "\n"
read -p "Please enter 'movie id'(1-1682):" n

echo -e "\n"
awk -F '|' -v num=$n '$1==num{print $0}' "$file1" 
echo -e "\n"

;;

2)
echo -e "\n"
read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n):" yorN
echo -e "\n"
if [ "y"=="$yorN" ]; then
	awk -F '|' '$7==1 && ++count <= 10 {print $1,$2}' "$file1"
else
	echo "0"	
fi
echo -e "\n"
;;

3)
echo -e "\n"
read -p "Please enter the 'movie id' (1~1682):" n

echo -e "\n"
s=0
c=0

awk_script='{ if ($2 == num) { sum+= $3; count++}}
END { avg = sum / count; printf("%.5f", avg) }'

formatted_sum=$(awk -v num="$n" -v count="$c" -f <(echo "$awk_script") "$file2")

echo "average rating of $n: $formatted_sum"
echo -e "\n"
;;

4)
echo -e "\n"
read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n):" yorN

echo -e "\n"
if [ "y"=="$yorN" ];then
	sed -n '1,10 { s/http[^|]*//g; p}' "$file1"
else
	echo "0"
fi
echo -e "\n"
;;

5)
echo -e "\n"
read -p "Do you want to get the data about users from 'u.user'?(y/n):" yorN
echo -e "\n"
if [ "y"=="$yorN" ];then

	sed -n '1,10 {s/^\([0-9]\+\)|\([0-9]\+\)|\([MF]\)|\([^|]\+\)|[0-9]\+$/user \1 is \2 years old \3 \4/; s/M/male/g; s/F/female/g; p;}' "$file3"
else
	echo "0"
fi
echo -e "\n"
;;

6)
echo -e "\n"
read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n)" yorN

echo -e "\n"
if [ "$yorN" == "y" ]; then
awk 'BEGIN {FS = "|"; OFS = "|"} NR >= 1673 && NR <= 1683 {
    split($3, date, "-");
    if (date[2] == "Jan") {
        date[2] = "01";
    } else if (date[2] == "Feb") {
        date[2] = "02";
    } else if (date[2] == "Mar") {
        date[2] = "03";
    } else if (date[2] == "Apr") {
        date[2] = "04";
    } else if (date[2] == "May") {
        date[2] = "05";
    } else if (date[2] == "Jun") {
        date[2] = "06";
    } else if (date[2] == "Jul") {
        date[2] = "07";
    } else if (date[2] == "Aug") {
        date[2] = "08";
    } else if (date[2] == "Sep") {
        date[2] = "09";
    } else if (date[2] == "Oct") {
        date[2] = "10";
    } else if (date[2] == "Nov") {
        date[2] = "11";
    } else if (date[2] == "Dec") {
        date[2] = "12";
    }
    new_date= date[3] date[2] date[1];
    $3 = new_date;
    print;
}' "$file1"

else
    echo "0"
fi

echo -e "\n"

;;

7)

echo -e "\n"

read -p "Please enter the 'user id' (1~943): " userId
echo -e "\n"

movieId=$(awk -v id="$userId" '$1 == id {print $2}' "$file2" | sort -n | tr '\n' '|')
echo "$movieId"

echo -e "\n"

awk -F "|" -v movieId="$movieId" '{split(movieId, value, "|");
for(i=0;i<=10;i++){
	if(value[i]==$1){
	print $1 "|" $2}
}}' "$file1"

echo -e "\n"

;;

8)
echo -e "\n"
read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" yorN
if [ "$yorN" == "y" ]; then

userId=$(awk -F "|" '$4=="programmer" && $2>=20 && $2<=29 {print $1}' "$file3")

awk -v userId="$userId" '{
        split(userId, userArray);
        movieId = $2;
        for(j in userArray) {
        if(userArray[j]==$1){
        movieRating[movieId]+=$3;
        movieCount[movieId]++;
	}
}}
END{
for (movie in movieRating){
if(movieCount[movie]!=0){
        avgRating = movieRating[movie] / movieCount[movie];
	avgRating = sprintf("%.5f", avgRating);
	sub(/0+$/, "", avgRating);
	sub(/\.$/, "", avgRating);
	printf("%d %s\n", movie, avgRating);
}}
}' "$file2"| sort -n

else
	echo "0"
fi

;;

esac

if [ $choiceNum = 9 ]; then
	echo "Bye!"
	break;
fi

done

