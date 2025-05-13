---
title: 'WireGuard mit systemd'
---

Für eine WireGuard-Verbindung mit systemd-networkd und systemd-resolved.

Alle Konfigurationsdateien gehören in `/etc/systemd/network/`.

## Interface

Das WireGuard-Interface anlegen (muss mit einer Zahl beginnen, z.B. `10-wg0.netdev`) ([Dokumentation](https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html))

```systemd
[NetDev]
Name=wg0
Kind=wireguard
Description=WireGuard-Tunnel für Casa Due Pur
MTUBytes=1320

[WireGuard]
PrivateKey=...
# Für alle Netze aus AllowedIPs soll automatisch eine Route erzeugt werden, in einer separaten Routing-Tabelle:
RouteTable=123
# Die verschlüsselten WireGuard-Pakete werden markiert:
FirewallMark=123
# Beides erlaubt spezielles Routing, konfiguriert in der *.network-Datei

[WireGuardPeer]
PublicKey=IaNBwGqXkxy4iLuowJQuR6h+AdL5Oo9oYtSqub8m6C4=
PresharedKey=...
AllowedIPs=fd42:167:84::1/64, 2a01:4f8:1c1c:1e5b::/64, 2a01:4f8:fff0:22::/64, 2a01:4f8:242:27a5::/64, 2a01:4f8:242:27a3::/64, 2003:a:241:4400::/56, 2003:a:27f:c144::/64, 159.69.238.80/28, 159.69.10.123/32, 87.140.122.88/32, 168.119.65.89/32, 168.119.65.91/32, 10.26.15.0/24, 192.168.2.0/24
Endpoint = vpn.casa-due-pur.de:51194
PersistentKeepalive=16
```

`PrivateKey=` und `PresharedKey=` entsprechend ausfüllen, den Rest sicherheitshalber nochmal abgleichen. Die Datei sollte für unprivilegierte Nutzer nicht lesbar sein, d.h. `chown root:systemd-network ...`, `chmod 640 ...`.

## Netzwerk

Nun das passende Netzwerk zum Interface anlegen (z.B. `wg0.network`) ([Dokumentation](https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html))

```systemd
[Match]
Name=wg0

[Network]
Address=...
Address=...

# Nur Domains mit dieser Endung über diesen DNS auflösen:
Domains=~casa-due-pur.de
DNS=2a01:4f8:fff0:22:ca9:16ff:fe6e:cc14
DNS=159.69.238.89
DNSDefaultRoute=false

[Link]
RequiredForOnline=no
# Optional: nicht automatisch beim Systemstart verbinden
ActivationPolicy=manual

# Die verschlüsselten WireGuard-Pakete sind mit 123 markiert und dürfen nicht über diese Verbindung geleitet werden.
# Die WireGuard-spezifischen Routen sind in einer Tabelle mit id 123.
# Diese Policy wendet die spezifischen Routen ausschliesslich auf unmarkierte Pakete an.
[RoutingPolicyRule]
FirewallMark=123
Table=123
InvertRule=true
Family=both
```

`Adress`en (ipv4 und ipv6) eintragen. Der Tunnel kann mit `networkctl up wg0` bzw `networkctl down wg0` nach Bedarf verbunden und getrennt werden.

Sobald der Tunnel verbunden ist, lässt sich die Routing-Tabelle mit `ip route show table 123` anzeigen. Die RoutingPolicy sollte in `ip rule` auftauchen.

## DNS

Wir haben jetzt zwei DNS-Server im System. Falls bei beiden `Domains=` gesetzt ist, muss der vorhandene Server explizite als default markiert werden (z.B. in `eth0.network`):

```systemd
[Network]
DNSDefaultRoute=true
```

## Firewall

Es wird kein Routing konfiguriert, daher sind normalerweise keine Änderungen an iptables notwendig.

Am Beispiel einer Firewall mit striktem whitelisting sind mindestens folgende Verbindungen zu erlauben:

* WireGuard-Traffic zum Endpoint `iptables -A OUTPUT -m owner ! --uid-owner 0-99999 -p udp -d 159.69.238.84 --dport 51194 -j ACCEPT` (Wireguard-Pakete kommen aus dem Kernel und sind keinem Benutzer zugeordnet)
* Ausgehender traffic auf wg0: `iptables -A OUTPUT -o wg0 -j ACCEPT`, ggf. mit `-m owner --uid-owner ...` auf einen Nutzer beschränkt.
* DNS-Traffic über den Tunnel: `iptables -A OUTPUT -m owner --uid-owner systemd-resolve -d 159.69.238.89 -o wg0 j ACCEPT`
* Eingehende pings und andere ICMP-Pakete auf wg0: `iptables -A INPUT -i wg0 -p icmp -j ACCEPT`
* Optional anderer eingehender Traffic auf wg0, z.B. ssh: `iptables -A INPUT -i wg0 -p tcp --dport 22 -j ACCEPT` (kann nicht nach Nutzer gefiltert werden)

Die Firewall muss verbindungsorientiert sein, üblicherweise mit einer der folgenden Methoden:

* Zugehörige Pakete werden direkt akzeptiert, z.B. mit `iptables -A INPUT/OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT` ([Tutorial](https://wiki.archlinux.org/title/Simple_stateful_firewall))
* Verbindungen werden markiert (statt `-j ACCEPT` nutzt man `-j CONNMARK --set-mark ...`) und markierte Verbindungen werden erlaubt (`iptables -A INPUT/OUTPUT -m connmark --mark ... -j ACCEPT`). Diese Variante ist umständlicher, erlaubt aber Traffic Shaping oder separate Statistiken pro verwendeter Markierung.

Für ipv6 sind äquivalente Regeln einzurichten.
