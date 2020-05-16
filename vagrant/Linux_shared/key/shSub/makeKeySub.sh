#!/bin/sh

execCmd() {
    echo -e "\e[32m$@\e[0m"
    "$@"
}

DIR=/vagrant/key/${HOSTNAME}/${USER}

execCmd mkdir -p ${DIR}
execCmd ls -l ${DIR}
execCmd ssh-keygen -t rsa -f ${DIR}/id_rsa -N ""
execCmd ls -l ${DIR}

# EOF
