printf "\e[1;93m[*] Enter to stopped Tor Service \e[0m \n"
read -e -p ""
killall -2 tor > /dev/null 2>&1
printf "\e[1;92m[*] All Tor connection stopped.\e[0m\n"
