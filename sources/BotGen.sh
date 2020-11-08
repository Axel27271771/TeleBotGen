#!/bin/bash

check_ip () {
MIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MIP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MIP" != "$MIP2" ]] && IP="$MIP2" || IP="$MIP"
echo "$IP" > /usr/bin/vendor_code
}

function_verify () {
  permited=$(curl -sSL "https://raw.githubusercontent.com/rudi9999/Control/master/Control-Bot")
  [[ $(echo $permited|grep "${IP}") = "" ]] && {
  clear
  echo -e "\n\n\n\e[31m====================================================="
  echo -e "\e[31m      ¡LA IP $(wget -qO- ipv4.icanhazip.com) NO ESTA AUTORIZADA!\n     SI DESEAS USAR EL BOTGEN CONTACTE A @Rufu99"
  echo -e "\e[31m=====================================================\n\n\n\e[0m"
  exit 1
  } || {
  ### INTALAR VERCION DE SCRIPT
  v1=$(curl -sSL "https://raw.githubusercontent.com/rudi9999/TeleBotGen/master/Vercion")
  echo "$v1" > /etc/ADM-db/vercion
  }
}

#check_ip
#function_verify
  
CIDdir=/etc/ADM-db && [[ ! -d ${CIDdir} ]] && mkdir ${CIDdir}
SRC="${CIDdir}/sources" && [[ ! -d ${SRC} ]] && mkdir ${SRC}
CID="${CIDdir}/User-ID" && [[ ! -e ${CID} ]] && echo > ${CID}
keytxt="${CIDdir}/keys" && [[ ! -d ${keytxt} ]] && mkdir ${keytxt}
[[ $(dpkg --get-selections|grep -w "jq"|head -1) ]] || apt-get install jq -y &>/dev/null
[[ ! -e "/bin/ShellBot.sh" ]] && wget -O /bin/ShellBot.sh https://raw.githubusercontent.com/rudi9999/TeleBotGen/master/ShellBot.sh &> /dev/null
[[ -e /etc/texto-bot ]] && rm /etc/texto-bot
LINE="==========================="

# Importando API
source ShellBot.sh
source ${SRC}/menu
source ${SRC}/ayuda
source ${SRC}/cache
source ${SRC}/invalido
source ${SRC}/status
source ${SRC}/reinicio
source ${SRC}/myip
source ${SRC}/id
source ${SRC}/back_ID
source ${SRC}/link
source ${SRC}/listID
source ${SRC}/gerar_key
source ${SRC}/power
source ${SRC}/comandos
source ${SRC}/update

# Token del bot
bot_token="$(cat ${CIDdir}/token)"

# Inicializando el bot
ShellBot.init --token "$bot_token" --monitor --flush --return map
ShellBot.username

botao_conf=''

ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text '/add' --callback_data '/add'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text '/del' --callback_data '/del'

reply () {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_from_id[$id]}

		 	 ShellBot.sendMessage	--chat_id  $var \
									--text "${callback_query_data}" \
									--parse_mode html \
									--reply_markup "$(ShellBot.ForceReply)"
	[[ "${callback_query_data}" = /del ]] && listID_src
}

ShellBot.regHandleFunction --function reply --callback_data /add
ShellBot.regHandleFunction --function reply --callback_data /del

menu_print () {
				ShellBot.sendMessage 	--chat_id ${message_chat_id[$id]} \
										--text "<i>$(echo -e $bot_retorno)</i>" \
										--parse_mode html \
										--reply_markup "$(ShellBot.InlineKeyboardMarkup -b 'botao_conf')"
}

download_file () {
# shellbot.sh editado linea 3986
user=User-ID
[[ -e ${CID} ]] && rm ${CID}
local file_id
          ShellBot.getFile --file_id ${message_document_file_id[$id]}
          ShellBot.downloadFile --file_path "${return[file_path]}" --dir "${CIDdir}"
local bot_retorno="ID user botgen\n"
		bot_retorno+="$LINE\n"
		bot_retorno+="Se restauro con exito!!\n"
		bot_retorno+="$LINE\n"
		bot_retorno+="${return[file_path]}\n"
		bot_retorno+="$LINE"
			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $bot_retorno)</i>" \
									--parse_mode html
return 0
}

msj_add () {
	      ShellBot.sendMessage --chat_id ${1} \
							--text "<i>$(echo -e $bot_retor)</i>" \
							--parse_mode html
}

upfile_fun () {
          ShellBot.sendDocument --chat_id ${message_chat_id[$id]}  \
                             --document @${1}
}

invalido_fun () {
local bot_retorno="$LINE\n"
         bot_retorno+="Comando invalido!\n"
         bot_retorno+="$LINE\n"
	     ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "<i>$(echo -e $bot_retorno)</i>" \
							--parse_mode html
	return 0	
}

msj_fun () {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
	      ShellBot.sendMessage --chat_id $var \
							--text "<i>$(echo -e "$bot_retorno")</i>" \
							--parse_mode html
	#return 0
}

# Ejecutando escucha del bot
while true; do
    ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
    for id in $(ShellBot.ListUpdates); do

    	ShellBot.watchHandle --callback_data ${callback_query_data[$id]}

	    chatuser="$(echo ${message_chat_id[$id]}|cut -d'-' -f2)"
	    echo $chatuser >&2
	    comando=(${message_text[$id]})
	    [[ ! -e "${CIDdir}/Admin-ID" ]] && echo "null" > ${CIDdir}/Admin-ID
	    permited=$(cat ${CIDdir}/Admin-ID)
	    comand
    done
done
