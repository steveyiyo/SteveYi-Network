#!/bin/bash

whois -h whois.radb.net '!i'"AS-STEVEYI-A" | sed '2!d; s/ /\n/g' | while read -r asn; do
    echo "$asn"
    v4_filter="$(bgpq3 -4l $asn"_v4" "$asn" -R 24)"
    v6_filter="$(bgpq3 -6l $asn"_v6" "$asn" -R 48)"
    asn_v4=${asn}_v4
    asn_v6=${asn}_v6
    vtysh <<EOF
config
$v4_filter
$v6_filter
route-map $asn_v4 permit 5
match ip address prefix-list $asn_v4
route-map $asn_v6 permit 5
match ipv6 address prefix-list $asn_v6
exit
exit
write
exit
EOF

done