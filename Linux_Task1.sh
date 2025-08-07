#!/bin/bash
actions=("ACCEPT" "REJECT" "LOG" "DNAT" "SNAT" "MASQUERADE")
while true; do
	while true; do
		read -p "Enter IP Address: " ip
		if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
			break
		else
			echo "wrong ip"	
		fi
	done

	while true; do
                read -p "Enter  port: " port
                if [[ $port =~ ^[0-9]+$ && $port -ge 0 && $port -le 65535 ]]; then
                        break
                else
			echo "out of range"
                fi
        done

	while true; do
                read -p "Enter  Action: " action
		action_upper=$(echo "$action" | tr '[:lower:]' '[:upper:]');
                if [[ " ${actions[@]} " =~ " $action_upper " ]]; then
                        break
                else
                	echo "out of range"
                fi
        done

	iptables -A INPUT -s "$ip" -p tcp --dport "$port" -j "$action_upper"
	iptables-save > /etc/rules.v4
	read -p " Do you wish to enter more rules? [y/n/Y/N] " bool
	case $bool in 
	[yY]) continue ;;
	*) break ;;
	esac	
done
cat /etc/rules.v4

 
