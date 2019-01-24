RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

linuxStatusCheck() {
	X=$(sudo systemctl status snips-* | grep -i -E 'Active|●')
	
	statusIsNext=false
	
	for i in $(echo $X | tr "●" "\n")
	do
	        if [[ $i =~ \.service$ ]]; then
	                service=${i/.service/}
	                printf "[Service] "
	                printf '%-25s' "$service: "
	        fi
	
	        if $statusIsNext ; then
	                if [[ $i =~ active$ ]]; then
	                        printf "${GREEN}[Active]${NC}\n"
	                else
	                        printf "${RED}[Inactive]${NC}\n"
	                fi
	
	                statusIsNext=false
	        fi
	
	        if [[ $i =~ Active: ]]; then
	                statusIsNext=true
	        fi
	done
}

macosStatusCheck() {
	X=$(brew services list | grep snips-)
	
	brew services list | grep snips- | while read -r line ; do
	        cpt=0
	        for i in $(echo $line | tr " " "\n")
	        do
	                cpt=$((cpt+1))
	
	                if [[ cpt -eq 1 ]] ; then
	                        printf "[Service] "
	                        printf '%-25s' "$i: "
	                fi
	
	                if [[ cpt -eq 2 ]] ; then
	                        if [[ $i = started$ ]] ; then
	                                printf "${GREEN}[Active]${NC}\n"
	                        else
	                                printf "${RED}[Inactive]${NC}\n"
	                        fi
	                fi
	        done
	done	
}

case "$OSTYPE" in
  darwin*)  macosStatusCheck ;; 
  cygwin*)     printf "${RED}Windows systems are not supported yet${NC}" ;;
  msys*)     printf "${RED}Windows systems are not supported yet${NC}" ;;
  win32*)     printf "${RED}Windows systems are not supported yet${NC}" ;;
  *)        linuxStatusCheck ;;
esac
