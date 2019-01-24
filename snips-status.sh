X=$(sudo systemctl status snips-* | grep -i -E 'Active|●')

statusIsNext=false

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'


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
