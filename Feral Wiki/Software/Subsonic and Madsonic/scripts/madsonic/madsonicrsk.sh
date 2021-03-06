#!/bin/bash
if [[ -d ~/private/madsonic ]]
then
    #
    httpport="$(sed -n -e 's/MADSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/madsonic/madsonic.sh 2> /dev/null)"
    #
    # v 1.2.0  Kill Start Restart Script generated by the Madsonic installer script
    #
    echo
    echo -e "\033[33m1:\e[0m This is the process PID:\033[32m$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)\e[0m used the last time \033[36m~/private/madsonic/madsonic.sh\e[0m was started."
    echo
    echo -e "\033[33m2:\e[0m This is the URL that Madsonic is configured to use:"
    echo
    echo -e "\033[31mMadsonic\e[0m last accessible at \033[31mhttps://$(hostname -f)/$(whoami)/madsonic/\e[0m"
    echo
    echo -e "\033[33m3:\e[0m Running instances checks:"
    echo
    echo -e "Checking to see, specifically, if the \033[32m$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)\e[0m is running"
    echo -e "\033[32m"
    if [[ -z "$(ps -p $(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) --no-headers 2> /dev/null)" ]]
    then
        echo -e "Nothing to show."
        echo -e "\e[0m"
    else
        ps -p "$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)" --no-headers 2> /dev/null
        echo -e "\e[0m"
    fi
    if [[ "$(ps -U $(whoami) | grep -c java)" -gt "1" ]]
    then
        echo -e "There are currently \033[31m$(ps -U $(whoami) | grep -c java 2> /dev/null)\e[0m running Java processes."
        echo -e "\033[31mWarning:\e[0m \033[32mMadsonic might not load or be unpredicatable with multiple instances running.\e[0m"
        echo -e "\033[33mIf there are multiple Madsonic processes please use the killall by using option [a] then use the restart option.\e[0m"
        echo -e "\033[31m"
        ps -U "$(whoami)" | grep java
        echo -e "\e[0m"
    fi
    echo -e "\033[33m4:\e[0m Options for killing and restarting Madsonic:"
    echo
    echo -e "\033[36mKill PID only\e[0m \033[31m[y]\e[0m \033[36mKillall java processes\e[0m \033[31m[a]\e[0m \033[36mSkip to restart (where you can quit the script)\e[0m \033[31m[r]\e[0m"
    echo
    read -ep "Please press one of these options [y] or [a] or [r] and press enter: "  confirm
    echo
    if [[ "$confirm" =~ ^[Yy]$ ]]
    then
        kill "$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)" 2> /dev/null
        echo -e "The process PID:\033[31m$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)\e[0m that was started by the installer or custom scripts has been killed."
        echo
        echo -e "Checking to see if the PID:\033[32m$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)\e[0m is running:\e[0m"
        echo -e "\033[32m"
        if [[ -z "$(ps -p $(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) --no-headers 2> /dev/null)" ]]
        then
            echo -e "Nothing to show, job done."
            echo -e "\e[0m"
        else
            ps -p "$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)" --no-headers 2> /dev/null
            echo -e "\e[0m"
        fi
    elif [[ "$confirm" =~ ^[Aa]$ ]]
    then
        killall -9 -u "$(whoami)" java 2> /dev/null
        echo -e "\033[31mAll java processes have been killed\e[0m"
        echo
        echo -e "\033[33mChecking for open java processes:\e[0m"
        echo -e "\033[32m"
        if [[ -z "$(ps -U $(whoami) | grep java 2> /dev/null)" ]]
        then
            echo -e "Nothing to show, job done."
            echo -e "\e[0m"
        else
            ps -U "$(whoami)" | grep java
            echo -e "\e[0m"
        fi
    else
        echo -e "Skipping to restart or quit"
        echo
    fi
    if [[ -f ~/private/madsonic/madsonic.sh ]]
    then
        read -ep "Would you like to restart Madsonic? [r] reload the kill features? [l] or quit the script? [q]: "  confirm
        echo
        if [[ "$confirm" =~ ^[Rr]$ ]]
        then
            if [[ -z "$(ps -p $(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) --no-headers 2> /dev/null)" ]]
            then
                bash ~/private/madsonic/madsonic.sh
                echo -e "Started Madsonic at PID:\033[31m$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)\e[0m"
                echo
                echo -e "\033[31mMadsonic\e[0m last accessible at \033[31mhttps://$(hostname -f)/$(whoami)/madsonic/\e[0m"
                echo -e "\033[32m"
                if [[ -z "$(ps -p $(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) --no-headers 2> /dev/null)" ]]
                then
                    echo -e "Nothing to show, job done."
                    echo -e "\e[0m"
                else
                    ps -p "$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)" --no-headers 2> /dev/null
                    echo -e "\e[0m"
                fi
                exit
            else
                echo -e "Madsonic with the PID:\033[32m$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)\e[0m is already running. Kill it first then restart"
                echo
                read -ep "Would you like to restart the RSK script and reload it? [y] or quit the script? [q] : "  confirmrsk
                echo
                if [[ "$confirmrsk" =~ ^[Yy]$ ]]
                then
                    bash ~/bin/madsonicrsk
                fi
                exit
            fi
        elif [[ "$confirm" =~ ^[Ll]$ ]]
        then
            echo -e "\033[31mReloading madsonicrsk to access kill features.\e[0m"
            echo
            bash ~/bin/madsonicrsk
        else
            echo This script has done its job and will now exit.
            echo
            exit
        fi
    else
        echo
        echo -e "The \033[31m~/private/madsonic/madsonic.sh\e[0m does not exist."
        echo -e "please run the \033[31m~/install.madsonic\e[0m to install and configure madsonic"
        exit
    fi
else
    echo -e "Madsonic is not installed"
fi
