#! /bin/bash
read -p "Enter Domain Name" domain

ip=$(nslookup "$domain"| awk '/^Address: / {print$2}' | tail -n1)
if [[ -z "$ip" ]]; then 
	echo "DNS Resolution Failed!"
	exit 1
fi
echo "$domain Resolved to $ip"
sudo ip6tables -A FORWARD -d "$ip" -j DROP
iptables-save > /etc/rules.v4
echo "Disallowed forwarding traffic to $domain"
cat /etc/rules.v4
