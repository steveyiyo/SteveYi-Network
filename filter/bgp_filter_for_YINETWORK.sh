#!/bin/bash

    v4_filter="$(bgpq3 -4l CLEARNET_v4 AS-STEVEYI -R 24)"
    v6_filter="$(bgpq3 -6l CLEARNET_v6 AS-STEVEYI -R 48)"
    asn_v4=${asn}_v4
    asn_v6=${asn}_v6
    vtysh <<EOF
config
$v4_filter
$v6_filter
route-map CLEARNET_v4 permit 5
match ip address prefix-list CLEARNET_v4
route-map CLEARNET_v6 permit 5
match ipv6 address prefix-list CLEARNET_v6
exit
exit
write
exit
EOF
