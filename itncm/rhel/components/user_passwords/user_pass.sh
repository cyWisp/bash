
function calc_user_age(){
    egrep "ksh|bash" /etc/passwd | egrep ":/home" | awk -F : '{print $1}' | while read user_account; do
        date_set=$(passwd -S ${user_account} | cut -d " " -f 3)
        printf "%s:%s\n" $user_account $date_set; 
    done
}

function read_age_results(){
    cat $user_age_temp | while read user_entry; do

        printf "%s\n" $user_entry
        creation_date=$(echo ${user_entry} | cut -d ":" -f 2)
        current_date=$(date +%Y-%m-%d)
        pw_age=$(echo $(( (`date -d $current_date +%s` - `date -d $creation_date +%s`) / 86400 )))
        pw_age_months=$(expr ${pw_age} / 30)

        printf "Password last set: %s days\n" $pw_age
        printf "Password age: %s months\n\n" $pw_age_months
    
        rm $user_age_temp
    done
}

printf "### CIP:007_6_R5:6__START ###\n"
printf "###__Check for user account password not changed within 15 calendar months ###\n\n"

user_age_temp="/tmp/userage"
calc_user_age > $user_age_temp
read_age_results

printf '\n### CIP:007_6_R5:6__END ###\n\n'

# calcusage > /tmp/userage

# for userage in $(cat /tmp/userage); do
#     A=$(echo $userage | cut -d : -f 2)
#     B=$(date +%Y-%m-%d)
#     C=$(echo $(( (`date -d $B +%s` - `date -d $A +%s`) / 86400 )))
#     D=395
#     if [ $C -gt $D ]; then
#         echo $(echo $userage | cut -d : -f 1)
#     fi
#     done


