[fwBasic]
status = enabled
incoming = deny
outgoing = allow
routed = disabled

[Rule0]
ufw_rule = 27036/udp ALLOW IN Anywhere
description = steam
command = /usr/sbin/ufw allow in proto udp from any to any port 27036
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 27036
iface = 
routed = 
logging = 

[Rule1]
ufw_rule = 44347/tcp ALLOW IN Anywhere
description = uxplay
command = /usr/sbin/ufw allow in proto tcp from any to any port 44347
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 44347
iface = 
routed = 
logging = 

[Rule2]
ufw_rule = 5353 ALLOW IN Anywhere
description = AirPlay
command = /usr/sbin/ufw allow in from any to any port 5353
policy = allow
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = 5353
iface = 
routed = 
logging = 

[Rule3]
ufw_rule = 3689 ALLOW IN Anywhere
description = AirPlay
command = /usr/sbin/ufw allow in from any to any port 3689
policy = allow
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = 3689
iface = 
routed = 
logging = 

[Rule4]
ufw_rule = 44068/udp ALLOW IN Anywhere
description = nordvpnd
command = /usr/sbin/ufw allow in proto udp from any to any port 44068
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 44068
iface = 
routed = 
logging = 

[Rule5]
ufw_rule = 22/tcp ALLOW IN Anywhere
description = sshd
command = /usr/sbin/ufw allow in proto tcp from any to any port 22
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 22
iface = 
routed = 
logging = 

[Rule6]
ufw_rule = 22000/tcp ALLOW IN Anywhere
description = syncthing
command = /usr/sbin/ufw allow in proto tcp from any to any port 22000
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 22000
iface = 
routed = 
logging = 

[Rule7]
ufw_rule = 52204/udp ALLOW IN Anywhere
description = avahi-daemon
command = /usr/sbin/ufw allow in proto udp from any to any port 52204
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 52204
iface = 
routed = 
logging = 

[Rule8]
ufw_rule = 21027/udp ALLOW IN Anywhere
description = syncthing
command = /usr/sbin/ufw allow in proto udp from any to any port 21027
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 21027
iface = 
routed = 
logging = 

[Rule9]
ufw_rule = 22000/udp ALLOW IN Anywhere
description = syncthing
command = /usr/sbin/ufw allow in proto udp from any to any port 22000
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 22000
iface = 
routed = 
logging = 

[Rule10]
ufw_rule = 53526/udp ALLOW IN Anywhere
description = syncthing
command = /usr/sbin/ufw allow in proto udp from any to any port 53526
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 53526
iface = 
routed = 
logging = 

[Rule11]
ufw_rule = 5355/tcp ALLOW IN Anywhere
description = systemd-resolved
command = /usr/sbin/ufw allow in proto tcp from any to any port 5355
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 5355
iface = 
routed = 
logging = 

[Rule12]
ufw_rule = 5355/udp ALLOW IN Anywhere
description = systemd-resolved
command = /usr/sbin/ufw allow in proto udp from any to any port 5355
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 5355
iface = 
routed = 
logging = 

[Rule13]
ufw_rule = 49175/udp ALLOW IN Anywhere
description = avahi-daemon
command = /usr/sbin/ufw allow in proto udp from any to any port 49175
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 49175
iface = 
routed = 
logging = 

[Rule14]
ufw_rule = 27036/tcp ALLOW IN Anywhere
description = steam
command = /usr/sbin/ufw allow in proto tcp from any to any port 27036
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 27036
iface = 
routed = 
logging = 

[Rule15]
ufw_rule = 33364/udp ALLOW IN Anywhere
description = syncthing
command = /usr/sbin/ufw allow in proto udp from any to any port 33364
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 33364
iface = 
routed = 
logging = 

[Rule16]
ufw_rule = 44348/tcp ALLOW IN Anywhere
description = uxplay
command = /usr/sbin/ufw allow in proto tcp from any to any port 44348
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 44348
iface = 
routed = 
logging = 

[Rule17]
ufw_rule = 27036/udp (v6) ALLOW IN Anywhere (v6)
description = steam
command = /usr/sbin/ufw allow in proto udp from any to any port 27036
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 27036
iface = 
routed = 
logging = 

[Rule18]
ufw_rule = 44347/tcp (v6) ALLOW IN Anywhere (v6)
description = uxplay
command = /usr/sbin/ufw allow in proto tcp from any to any port 44347
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 44347
iface = 
routed = 
logging = 

[Rule19]
ufw_rule = 5353 (v6) ALLOW IN Anywhere (v6)
description = AirPlay
command = /usr/sbin/ufw allow in from any to any port 5353
policy = allow
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = 5353
iface = 
routed = 
logging = 

[Rule20]
ufw_rule = 3689 (v6) ALLOW IN Anywhere (v6)
description = AirPlay
command = /usr/sbin/ufw allow in from any to any port 3689
policy = allow
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = 3689
iface = 
routed = 
logging = 

[Rule21]
ufw_rule = 44068/udp (v6) ALLOW IN Anywhere (v6)
description = nordvpnd
command = /usr/sbin/ufw allow in proto udp from any to any port 44068
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 44068
iface = 
routed = 
logging = 

[Rule22]
ufw_rule = 22/tcp (v6) ALLOW IN Anywhere (v6)
description = sshd
command = /usr/sbin/ufw allow in proto tcp from any to any port 22
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 22
iface = 
routed = 
logging = 

[Rule23]
ufw_rule = 22000/tcp (v6) ALLOW IN Anywhere (v6)
description = syncthing
command = /usr/sbin/ufw allow in proto tcp from any to any port 22000
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 22000
iface = 
routed = 
logging = 

[Rule24]
ufw_rule = 52204/udp (v6) ALLOW IN Anywhere (v6)
description = avahi-daemon
command = /usr/sbin/ufw allow in proto udp from any to any port 52204
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 52204
iface = 
routed = 
logging = 

[Rule25]
ufw_rule = 21027/udp (v6) ALLOW IN Anywhere (v6)
description = syncthing
command = /usr/sbin/ufw allow in proto udp from any to any port 21027
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 21027
iface = 
routed = 
logging = 

[Rule26]
ufw_rule = 22000/udp (v6) ALLOW IN Anywhere (v6)
description = syncthing
command = /usr/sbin/ufw allow in proto udp from any to any port 22000
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 22000
iface = 
routed = 
logging = 

[Rule27]
ufw_rule = 53526/udp (v6) ALLOW IN Anywhere (v6)
description = syncthing
command = /usr/sbin/ufw allow in proto udp from any to any port 53526
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 53526
iface = 
routed = 
logging = 

[Rule28]
ufw_rule = 5355/tcp (v6) ALLOW IN Anywhere (v6)
description = systemd-resolved
command = /usr/sbin/ufw allow in proto tcp from any to any port 5355
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 5355
iface = 
routed = 
logging = 

[Rule29]
ufw_rule = 5355/udp (v6) ALLOW IN Anywhere (v6)
description = systemd-resolved
command = /usr/sbin/ufw allow in proto udp from any to any port 5355
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 5355
iface = 
routed = 
logging = 

[Rule30]
ufw_rule = 49175/udp (v6) ALLOW IN Anywhere (v6)
description = avahi-daemon
command = /usr/sbin/ufw allow in proto udp from any to any port 49175
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 49175
iface = 
routed = 
logging = 

[Rule31]
ufw_rule = 27036/tcp (v6) ALLOW IN Anywhere (v6)
description = steam
command = /usr/sbin/ufw allow in proto tcp from any to any port 27036
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 27036
iface = 
routed = 
logging = 

[Rule32]
ufw_rule = 33364/udp (v6) ALLOW IN Anywhere (v6)
description = syncthing
command = /usr/sbin/ufw allow in proto udp from any to any port 33364
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 33364
iface = 
routed = 
logging = 

[Rule33]
ufw_rule = 44348/tcp (v6) ALLOW IN Anywhere (v6)
description = uxplay
command = /usr/sbin/ufw allow in proto tcp from any to any port 44348
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 44348
iface = 
routed = 
logging = 

