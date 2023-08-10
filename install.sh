#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color
myIP="$(dig +short myip.opendns.com @resolver1.opendns.com)"

installApps()
{
    clear
    OS="$REPLY" ## <-- This $REPLY = OS Selection
    echo -e "${NC}You can Install ${GREEN}Uptime Kuma${NC} with this script!${NC}"
    echo -e "Please select ${GREEN}'y'${NC} for each item you would like to install."
    echo -e "${RED}NOTE:${NC} Without Docker and Docker-Compose, you cannot install this container.${NC}"
    echo -e ""
    echo -e "To install Docker and Docker-Compose, use the link below:"
    echo -e "${GREEN}https://github.com/shawshanck/Docker-and-Docker-Compose${NC}"
    echo -e ""
    echo -e "      ${CYAN}Provided to you by ${YELLOW}Mohammad Mohammadpour${NC}"
    echo -e "          ${YELLOW}https://github.com/shawshanck${NC}"
    echo -e ""
    
    ISACT=$( (sudo systemctl is-active docker ) 2>&1 )
    ISCOMP=$( (docker-compose -v ) 2>&1 )

    #### Try to check whether docker is installed and running - don't prompt if it is
    
    read -rp "Uptime Kuma (y/n): " UPK

    startInstall
}

startInstall() 
{
    clear
    echo -e "*******************************************************"
    echo -e "***         Preparing for Installation              ***"
    echo -e "*******************************************************"
    echo -e ""
    sleep 3s


    if [[ "$UPK" == [yY] ]]; then
        echo -e "*******************************************************"
        echo -e "***              Install Uptime Kuma                ***"
        echo -e "*******************************************************"
        echo -e "${MAGENTA}      *.${NC}${GREEN} Installing netstat:${NC}"

        sudo apt install net-tools
        sudo yum install net-tools
        sudo emerge -a sys-apps/net-tools
        sudo apk add net-tools
        sudo pacman -S net-tools
        sudo zypper install net-tools

        # Starting bash to create user defined parameters
        echo -e "${MAGENTA}      1.${NC}${GREEN} Please define each parameters:${NC}"

        mkdir docker -p && mkdir docker/uptimekuma -p && cd docker/uptimekuma && mkdir config
        sudo netstat -tulpn | grep LISTEN

        read -e -p "Please enter a Port for Uptime Kuma: " -i "33031" upkp
        upkp=${upkp:-"33031"}

        echo "version: '3'

        volumes:
            uptimekuma-data:
            driver: local

        services:
            uptimekuma:
                image: louislam/uptime-kuma:latest
                container_name: uptimekuma
                ports:
                 - ${upkp:-"33031"}:3001
            volumes:
                 - /root/docker/uptimekuma/config:/app/data
                 - /var/run/docker.sock:/var/run/docker.sock
            restart: unless-stopped" > docker-compose.yml



	echo ""        
	echo -e "${MAGENTA}      2.${NC}${GREEN} Running the docker-compose.yml to install and start Uptime Kuma${NC}"
        echo ""
        echo ""

          docker-compose up -d
          sudo docker-compose up -d

	echo ""
	echo -e "${MAGENTA}      3.${NC}${GREEN} Installation Completed. Details are:${NC}"
        echo -e ""
        echo -e "${NC}     Uptime Kuma is running on: http://${GREEN}${myIP}:${upkp:-"33031"}${NC}"

        echo -e ""
        echo -e ""
        echo -e "      ${CYAN}Provided to you by ${YELLOW}Mohammad Mohammadpour${NC}"
        echo -e "          ${YELLOW}https://github.com/shawshanck${NC}"
        echo -e ""
        cd
    fi
    
    exit 1
}

echo ""
echo ""

clear

echo -e "${YELLOW}Let's figure out which OS / Distro you are running.${NC}"
echo -e ""
echo -e ""
echo -e "${GREEN}    From some basic information on your system, you appear to be running: ${NC}"
echo -e "${GREEN}        --  OS Name            ${NC}" $(lsb_release -i)
echo -e "${GREEN}        --  Description        ${NC}" $(lsb_release -d)
echo -e "${GREEN}        --  OS Version         ${NC}" $(lsb_release -r)
echo -e "${GREEN}        --  Code Name          ${NC}" $(lsb_release -c)
echo -e ""
echo -e "${YELLOW}------------------------------------------------${NC}"
echo -e ""

PS3="Please enter 1 to install Uptime Kuma or 2 to exit setup. "
select _ in \
    "Install Uptime Kuma" \
    "Exit"
do
  case $REPLY in
    1) installApps ;;
    2) exit ;;
    *) echo "Invalid selection, please try again..." ;;
  esac
done
