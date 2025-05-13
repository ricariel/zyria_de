#!/bin/sh
#
# Extract DNS zone from Samba4 native DNS using samba-tool
#
# Prerequistes:
# samba krb5-workstation

SAMBA_TOOL=samba-tool

#kinit Administrator
#trap "kdestroy; rm -f $TMPFILE" 0 1 2 15
#klist
## -k=yes doesn't work...
## Using --password isn't secure.
USER=Administrator
echo -n "$USER password:" >&2; stty -echo; read PASS; stty echo; echo '' >&2
echo 'Please ignore "Cannot do GSSAPI to an IP address" errors...' >&2

## Extract zones
#  2 zone(s) found
#
#  pszZoneName                 : a.example.or.jp
#  Flags                       : DNS_RPC_ZONE_DSINTEGRATED DNS_RPC_ZONE_UPDATE_SECURE
#  ZoneType                    : DNS_ZONE_TYPE_PRIMARY
#  Version                     : 50
#  dwDpFlags                   : DNS_DP_AUTOCREATED DNS_DP_DOMAIN_DEFAULT DNS_DP_ENLISTED
#  pszDpFqdn                   : DomainDnsZones.a.example.or.jp
#
#  pszZoneName                 : _msdcs.a.example.or.jp
#  Flags                       : DNS_RPC_ZONE_DSINTEGRATED DNS_RPC_ZONE_UPDATE_SECURE
#  ZoneType                    : DNS_ZONE_TYPE_PRIMARY
#  Version                     : 50
#  dwDpFlags                   : DNS_DP_AUTOCREATED DNS_DP_FOREST_DEFAULT DNS_DP_ENLISTED
#  pszDpFqdn                   : ForestDnsZones.a.example.or.jp

#$SAMBA_TOOL dns zonelist localhost --kerberos=yes > $TMPFILE
ZONES=`$SAMBA_TOOL dns zonelist localhost -U "$USER" --password "$PASS" | awk '$1 ~ /pszZoneName/{print $3}'`

## queryzone $zone "ForestDnsZones"
queryzone () {
  local zone="$1"
  local entry="$2"
  local qentry="$entry"
  local name
  local children
  local lhs
  test -z "$entry" && qentry="@"

  $SAMBA_TOOL dns query localhost $zone "$qentry" ALL -U "$USER" --password "$PASS" |
#  Name=, Records=3, Children=0
#    SOA: serial=1, refresh=900, retry=600, expire=86400, minttl=3600, ns=ad01.a.example.or.jp., email=hostmaster.a.example.or.jp. (flags=600000f0, serial=1, ttl=3600)
#    NS: ad01.a.example.or.jp. (flags=600000f0, serial=1, ttl=900)
#    A: 100.64.96.31 (flags=600000f0, serial=1, ttl=900)
#  Name=_msdcs, Records=0, Children=0
#  Name=_sites, Records=0, Children=1
#  Name=_tcp, Records=0, Children=4
  while read line; do
    set $line
    case "$1" in
        Name=*,)
      name=`expr $1 : 'Name=\([^,]*\)*,'`
      children=`expr $3 : 'Children=\([0-9]*\)'`
      if [ $children -gt 0 ]; then
        queryzone $zone $name${entry:+.}$entry
      fi
      if [ -z "$name" ]; then
        if [ -z "$entry" ]; then
          lhs="@"
        else
          lhs="${entry}"
        fi
      else
        lhs="${name}${entry:+.}${entry}"
      fi
      ;;
        SOA:)
#    SOA: serial=1, refresh=900, retry=600, expire=86400, minttl=3600, ns=ad01.a.example.or.jp., email=hostmaster.a.example.or.jp. (flags=600000f0, serial=1, ttl=3600)
      echo "$@" | sed -e 's/.*serial=\([0-9]*\), refresh=\([0-9]*\), retry=\([0-9]*\), expire=\([0-9]*\), minttl=\([0-9]*\), ns=\([^,]*\), email=\([^,]*\) (flags=.*, serial=[0-9]*, ttl=\([0-9]*\))/'"${name:-@}"' \8  IN SOA \6 \7 \1 \2 \3 \4 \5/'
      ;;
#    NS: ad01.a.example.or.jp. (flags=600000f0, serial=1, ttl=900)
#    A: 100.64.96.31 (flags=600000f0, serial=1, ttl=900)
        NS:|A:|AAAA:)
      echo "$@" | sed -ne 's/\([^ ]*\): \([^ ]*\) (flags=[0-9a-f]*, serial=[0-9]*, ttl=\([0-9]*\)).*/'"${lhs}"' \3 IN \1  \2/p'
      ;;
#    SRV: ad01.a.example.or.jp. (88, 0, 100) (flags=f0, serial=1, ttl=900)
        SRV:|MX:)
      echo "$@" | sed -ne 's/\([^ ]*\): \([^ ]*\) (\([0-9]*\), \([0-9]*\), \([0-9]*\)) (flags=[0-9a-f]*, serial=[0-9]*, ttl=\([0-9]*\)).*/'"${lhs}"'  \6 IN \1  \4 \5 \3 \2/p'
      ;;
#    CNAME: ad01.a.example.or.jp. (flags=f0, serial=1, ttl=900)
        CNAME:)
      echo "$@" | sed -ne 's/\([^ ]*\): \([^ ]*\) (flags=[0-9a-f]*, serial=[0-9]*, ttl=\([0-9]*\)).*/'"${lhs}"' \3 IN \1  \2/p'
      ;;
        *)
      echo "ERROR unknown record type $1; aborting" >&2; exit 1
      ;;
    esac
  done
}

echo Zones: $ZONES >&2
for zone in $ZONES; do
  echo '$ORIGIN' $zone
  echo ''
  queryzone $zone ""
  echo ''
done ;# zone $ZONES
