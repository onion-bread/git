#!/bin/sh

usage() {
    echo "usage: `basename $0` hostname"
    exit 1
}

execCmd() {
    echo -e "\e[32m$@\e[0m"
    "$@"
}

if [ $# -ne 1 ]; then
    usage
fi
host=$1

keyDir=/vagrant/key
subCmd=${keyDir}/shSub/makeKeySub.sh

# 前処理
execCmd rm -fr ${keyDir}/${host}
hostOrg=`hostname`
execCmd hostnamectl set-hostname $host

# メイン処理
prompt="\](#|\\\\\$) "
for user in root vagrant
do
    expect -c "
        set timeout 5
        spawn su - $user
        expect -re \"${prompt}\" { send \"${subCmd}\r\" }
        expect -re \"${prompt}\" { send \"exit\r\" }
        expect eof
    "
done

# 後処理
execCmd hostnamectl set-hostname $hostOrg

# EOF
