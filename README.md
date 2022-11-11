# Forward DNS wildcards to IP

## Motivation

Sometimes needs all subdomains of a domain to point to a single IP address. This is useful for testing, staging, or development environments. You can edit `/etc/hosts` file. But if there are many domains, it sometime hard to setup it. This project is simple solution for resolving this problem.

## Usage

for example our dev domain is `dev.com` and we want to point all subdomains to some IP address:

```text
subdomain01.dev.com -> 127.0.0.1
subdomain02.dev.com -> 127.0.0.1
...
subdomain99.dev.com -> 127.0.0.1
```

### For MacOS users

```bash
mkdir -p /etc/resolver/

cat > /etc/resolver/dev.com <<EOF
domain dev.com
search dev.com
nameserver 127.0.0.2
EOF

# add internal ip
ifconfig lo0 alias 127.0.0.2 up

# flush dns
dscacheutil -flushcache
killall -HUP mDNSResponder
```

## For Linux users

```bash
cat > /etc/systemd/resolved.conf <<EOF
[Resolve]
DNS=127.0.0.2
Domains=~dev.com
EOF

# restart systemd-resolved
service systemd-resolved restart
```

## Start custom DNS server

need to run this custom DNS server, where `WILDCARD` is regexp to resolve domains, `SERVER_IP` is IP address to resolve domains

```bash
docker run -d --restart=always \
-e SERVER_IP=127.0.0.1 \
-e WILDCARD=".*\.dev\.com" \
-p 127.0.0.2:53:53/udp \
paskalmaksim/forward-wildcard-dns:latest
```