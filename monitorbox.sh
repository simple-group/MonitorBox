#!/bin/bash

######################################################################
#      MonitorBox V3 - Fidèle au code d'origine (Mode Stable)        #
######################################################################

CONFIG_FILE="servers.conf"
WEB_DATA_FILE="data.js"
HISTORY_FILE="history.dat"
MAX_HISTORY=20

# Config Pager
DEVICE="/dev/ttyS0"
BAUD=9600
CAPCODE="1234567"

CYCLE_COUNT=0

trigger_pager() {
    local message="$1"
    # stty -F "$DEVICE" $BAUD cs8 -cstopb -parenb -ixon -ixoff
    # printf "\x19R%s\x8A%s\x18" "$CAPCODE" "$message" > "$DEVICE"
}

while true
do
    CYCLE_COUNT=$((CYCLE_COUNT+1))
    clear
    echo ============================================
    date
    echo "Cycle de monitoring n°: $CYCLE_COUNT"
    echo ============================================

    JS_SERVER_LIST=""
    COUNT_PING_OK=0
    COUNT_WEB_OK=0

    while IFS=';' read -r url name use_ping grep_keyword espeak_msg use_pager || [ -n "$url" ]; do
        
        [[ $url =~ ^#.*$ ]] || [[ -z $url ]] && continue

        echo
        echo > tmp
        # UTILISATION STRICTE DE TA METHODE D'ORIGINE
        curl -o tmp "$url"
        
        # Initialisation variables pour le Web (HTML)
        IS_DOWN=0
        PING_STATUS="N/A"
        WEB_STATUS="OK"
        CSS_CLASS="online"

        # Verification du PING si demandé
        if [ "$use_ping" == "yes" ]; then
            # Extraction propre de l'hôte (fonctionne pour https://google.com ou 1.1.1.1)
            # On retire le protocole (http/https) et tout ce qui suit le slash
            host=$(echo "$url" | sed -e 's|^[^/]*//||' -e 's|/.*||')
            
            # Exécution du ping et capture de la latence
            # On envoie 1 seul paquet avec un timeout de 1 seconde
            ping_output=$(ping -c 1 -W 1 "$host" 2>/dev/null)
            
            if [ $? -eq 0 ]; then
                # On extrait la valeur du temps (ex: 12.5)
                ping_ms=$(echo "$ping_output" | grep "time=" | awk -F'time=' '{print $2}' | awk '{print $1}')
                PING_STATUS="${ping_ms}ms"
                COUNT_PING_OK=$((COUNT_PING_OK+1))
                echo -e " -> Ping : \e[1;36m$PING_STATUS\e[00m"
            else
                PING_STATUS="KO"
                echo -e " -> Ping : \e[1;31mKO\e[00m"
            fi
        fi

        # TEST 1 (Copie conforme de ton IF/THEN/ELSE)
        if grep -q "$grep_keyword" tmp
        then 
            echo -e "\e[1;32m------------------- | $name : UP\e[00m"
            COUNT_WEB_OK=$((COUNT_WEB_OK+1))
            sleep 4s
        else 
            echo
            echo "Test 1 ERROR" & espeak "Captain, incoming message"
            echo 
            sleep 59s
            echo > tmp
            curl -o tmp "$url"
            
            # TEST 2 (RETRY)
            if grep -q "$grep_keyword" tmp
            then
                echo -e "\e[1;32m------------------- | $name : UP\e[00m"
                COUNT_WEB_OK=$((COUNT_WEB_OK+1))
                WEB_STATUS="OK"
            else            
                echo -e "\e[1;31m------------------ | $name : DOWN\e[00m"
                IS_DOWN=1
                WEB_STATUS="KO"
                CSS_CLASS="offline"

                # Alertes sonores et Pager
                if [ ! -z "$espeak_msg" ]; then espeak "$espeak_msg" 2>/dev/null & fi
                if [ "$use_pager" == "yes" ]; then trigger_pager "ALERT: $name DOWN"; fi
            fi
        fi

        # Ajout à la liste pour le Dashboard HTML
        JS_SERVER_LIST+="{ name: \"$name\", url: \"$url\", use_pager: \"$use_pager\", class: \"$CSS_CLASS\", ping: \"$PING_STATUS\", web: \"$WEB_STATUS\" },"

    done < "$CONFIG_FILE"

    # --- GENERATION DES DONNEES WEB ---
    echo "$COUNT_PING_OK $COUNT_WEB_OK" >> "$HISTORY_FILE"
    if [ $(wc -l < "$HISTORY_FILE") -gt $MAX_HISTORY ]; then
        tail -n $MAX_HISTORY "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
    fi

    HISTORY_PING_JS="[$(awk '{printf "%s,", $1}' "$HISTORY_FILE" | sed 's/,$//')]"
    HISTORY_WEB_JS="[$(awk '{printf "%s,", $2}' "$HISTORY_FILE" | sed 's/,$//')]"
    NOW=$(date '+%d/%m/%Y %H:%M:%S')
    
    cat <<EOF > "$WEB_DATA_FILE"
const lastUpdate = "$NOW";
const cycleCount = $CYCLE_COUNT;
const serverData = [
    ${JS_SERVER_LIST%,}
];
const historyPing = $HISTORY_PING_JS;
const historyWeb = $HISTORY_WEB_JS;
EOF

    echo
    echo "Cycle terminé. Export Web mis à jour."
    sleep 44s
done
