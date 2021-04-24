#!/usr/bin/env bash
apk add cargo go zlib bzip2
cargo install bgptools
go get github.com/zhanhb/cidr-merger
ln -sf  ~/.cargo/bin/bgptools /usr/local/bin/
ln -sf  ~/go/bin/cidr-merger /usr/local/bin/

# https://github.com/RIPE-NCC/bgpdump/wiki
cd /tmp/
git clone https://github.com/RIPE-NCC/bgpdump
cd bgpdump
sh ./bootstrap.sh
make
./bgpdump -T
cp bgpdump /usr/local/bin/

set -e

cidr-merger --version || {
    curl -sL -o ~/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
    chmod +x ~/bin/gimme
    eval "$(gimme stable)"
    go get github.com/zhanhb/cidr-merger
}
bgptools --version | grep -F $BGPTOOLS_VERSION || \
    cargo install --vers $BGPTOOLS_VERSION bgptools

cidr-merger --version
bgptools --version
