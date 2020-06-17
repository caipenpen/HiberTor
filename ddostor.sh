#!/bin/bash
# ddostor: DDoS Tool v1.0 using Torshammer
# Coded by @thelinuxchoice
# Github: https://github.com/thelinuxchoice/ddostor


trap 'printf "\n";stop;exit 1' 2

checkroot() {
if [[ "$(id -u)" -ne 0 ]]; then
   printf "\e[1;77m Please, run this program as root!\n \e[0m"
   exit 1
fi
}

changeip() {


killall -HUP tor

}

banner() {

printf "\e[1;93m  ____  ____       ____ \e[0m \e[1;77m  _             \e[0m\n"
printf "\e[1;93m |  _ \|  _ \  ___/ ___| \e[0m\e[1;77m | |_ ___  _ __  \e[0m\n"
printf "\e[1;93m | | | | | | |/ _ \___ \ \e[0m\e[1;77m | __/ _ \| '__| \e[0m\n"
printf "\e[1;93m | |_| | |_| | (_) |__) |\e[0m\e[1;77m | || (_) | |    \e[0m\n"
printf "\e[1;93m |____/|____/ \___/____/\e[0m\e[1;77m   \__\___/|_|    v1.0\e[0m\n"
printf "                                          \n"
printf "\e[1;92m  .::.\e[0m\e[1;77m DDoS Tool by @thelinuxchoice  \e[0m\e[1;92m.::.\e[0m\n\n"
printf "\e[1;92m  .::.\e[0m\e[1;77m EDIT Tool by WachiraChoomsiri  \e[0m\e[1;92m.::.\e[0m\n\n"

}

config() {

default_tor="y"

inst="${inst:-${default_inst}}"
read -e -p $'\e[1;92m[\e[0m\e[1;77m?\e[0m\e[1;92m] Anonymized via Tor? \e[0m\e[1;77m[Y/n]: \e[0m' tor
rm proxy.txt
printf "\e[0m"
tor="${tor:-${default_tor}}"
if [[ $tor == "y" || $tor == "Y" ]]; then
readinst
printf "\e[1;93m[*] Press Ctrl + C to stop Tor Service \e[0m \n"
stop
else
stop
fi
}



readinst() {
default_inst="3"
read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Tor instances \e[0m\e[1;77m(default: 3): \e[0m' inst
inst="${inst:-${default_inst}}"
multitor
}


checktor() {
let i=1
checkcount=0 
while [[ $i -le $inst ]]; do
port=$((9050+$i))
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Checking Tor connection on port:\e[0m\e[1;77m %s\e[0m..." $port

check=$(curl --socks5-hostname localhost:$port -s https://www.google.com > /dev/null; echo $?) 
if [[ "$check" -gt 0 ]]; then 
printf "\e[1;91mFAIL!\e[0m\n" 
else 
printf "\e[1;92mOK!\e[0m\n" 
let checkcount++ 
fi
i=$((i+1))
done

if [[ $checkcount != $inst ]]; then
printf "\e[1;93m[!] It requires all tor running!\e[0m\n"
printf "\e[1;77m1) Check again\e[0m\n"
printf "\e[1;77m2) Restart\n\e[0m"
printf "\e[1;77m3) Exit\n\e[0m"
read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Choose an option: \e[0m' fail  


if [[ $fail == "1" ]]; then
checktor
elif [[ $fail == "2" ]]; then
stop
multitor
elif [[ $fail == "3" ]]; then
exit 1
else
printf "\e[1;93m[!] Invalid option, exiting...!\e[0m\n"
exit 1
fi
fi
}

multitor() {


if [[ ! -d multitor ]]; then 
mkdir multitor;
fi
default_ins="1"
inst="${inst:-${default_inst}}"

let i=1
while [[ $i -le $inst ]]; do
port=$((9050+$i))
printf "SOCKSPort %s\nDataDirectory /var/lib/tor%s" $port $i > multitor/multitor$i 
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Starting Tor on port:\e[0m\e[1;77m %s\e[0m\n" $port 
tor -f multitor/multitor$i > /dev/null &
echo "127.0.0.1:"$port >> proxy.txt
i=$((i+1))
done
checktor
}

stop() {
printf "\e[1;92m[*] All Tor Service Started.\e[0m\n"
printf "\e[1;92m[*] Kill use ./killtor.sh \e[0m\n"
python3 HibertorV1.py
}

banner
checkroot
config

