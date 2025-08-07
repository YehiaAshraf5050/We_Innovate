#! /bin/bash
read -p "Enter Domain Name: " domain
for ip4 in $(dig +short "$domain" A); do
    echo "Blocking IPv4: $ip4"
    sudo iptables -A OUTPUT -d "$ip4" -j DROP
done
for ip6 in $(dig +short "$domain" AAAA); do
    echo "Blocking IPv6: $ip6"
    sudo ip6tables -A OUTPUT -d "$ip6" -j DROP
done

sudo iptables-save > /etc/rules.v4
sudo ip6tables-save > /etc/rules.v6

echo "Disallowed forwarding traffic to $domain"
cat /etc/rules.v6
cat /etc/rules.v4
