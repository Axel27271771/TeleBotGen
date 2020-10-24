#!/bin/bash

dirb="/etc/ADM-db" && [[ ! -d ${dirb} ]] && mkdir ${dirb}
dirs="${dirb}/sources" && [[ ! -d ${dirs} ]] && mkdir ${dirs}
SCPresq="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL3J1ZGk5OTk5L1RlbGVCb3RHZW4vbWFzdGVyL3NvdXJjZXM="
SUB_DOM='base64 -d'
bar="\e[0;36m=====================================================\e[0m"

update () {
PID_GEN=$(ps x|grep -v grep|grep "BotGen.sh")
[[ $PID_GEN ]] && start_bot
[[ -d ${dirs} ]] && rm -rf ${dirs}
[[ -e ${dirb} ]] && rm ${dirb}/BotGen.sh
[[ -e /bin/ShellBot.sh ]] && rm /bin/ShellBot.sh
cd $HOME
REQUEST=$(echo $SCPresq|$SUB_DOM)
wget -O "$HOME/lista-arq" ${REQUEST}/lista-bot > /dev/null 2>&1
sleep 1s
if [[ -e $HOME/lista-arq ]]; then
for arqx in `cat $HOME/lista-arq`; do
wget -O $HOME/$arqx ${REQUEST}/${arqx} > /dev/null 2>&1 && [[ -e $HOME/$arqx ]] && veryfy_fun $arqx
done
fi
 rm $HOME/lista-arq
 start_bot
}

veryfy_fun () {
dirs="${dirb}/sources" && [[ ! -d ${dirs} ]] && mkdir ${dirs}
dirs="${dirb}/sources" && [[ ! -d ${dirs} ]] && mkdir ${dirs}
unset ARQ
case $1 in
"BotGen.sh")ARQ="${dirb}";;
*)ARQ="${dirs}";;
esac
mv -f $HOME/$1 ${ARQ}/$1
chmod +x ${ARQ}/$1
}

start_bot () {
# [[ ! -e "${CIDdir}/token" ]] && echo "null" > ${CIDdir}/token
unset PIDGEN
PIDGEN=$(ps aux|grep -v grep|grep "BotGen.sh")
if [[ ! $PIDGEN ]]; then
screen -dmS teleBotGen ${CIDdir}/BotGen.sh
else
killall BotGen.sh
fi
}

update
