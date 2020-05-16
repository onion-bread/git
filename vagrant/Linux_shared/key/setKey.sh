#!/bin/sh
#------------------------------------------------------------------------------
# コントローラの鍵を、コントローラ・ノードに配置する
#------------------------------------------------------------------------------

HOSTNAME=`hostname`
TMPFILE=/tmp/$$

# 作成済みの鍵ファイルの格納ディレクトリ
KEYDIR=/vagrant/key

# アカウント毎の鍵ファイル・コンフィグ
AUTH_KEYS=authorized_keys
PRIVATE_KEY=id_rsa
PUBLIC_KEY=id_rsa.pub
SSH_CONFIG=config

# ansibleのログインアカウント
ANSIBLE_USER=vagrant
ANSIBLE_GROUP=${ANSIBLE_USER}

# ansibleコントローラ
CONTROLLER=""
case "${HOSTNAME}" in
  controller|node*)
    CONTROLLER=controller
    ;;
  *)
    CONTROLLER=${HOSTNAME}
    ;;
esac

#------------------------------------------------------------------------------
# 色付きでecho表示する
#------------------------------------------------------------------------------
Echo() {
    echo -e "\e[32m$@\e[0m"
}

#------------------------------------------------------------------------------
# 関数の実行結果を取得する
#------------------------------------------------------------------------------
get_ret() {
    RET=`cat ${TMPFILE}`
    rm -f ${TMPFILE}
    echo ${RET}
}

#------------------------------------------------------------------------------
# アカウントのグループを取得する
# $1:アカウント
# 戻り値:グループ
#------------------------------------------------------------------------------
get_group() {

    GRPUP=vagrant
    if [ "$1" = "root" ]; then
        GROUP=root
    fi

    echo ${GROUP}
}

#------------------------------------------------------------------------------
# .sshディレクトリを生成する
# $1:アカウント
# 戻り値:生成したディレクトリ名
#------------------------------------------------------------------------------
make_sshdir() {

    DIR=/home/$1/.ssh
    if [ "$1" = "root" ]; then
        DIR=/$1/.ssh
    fi

    if [ ! -d "${DIR}" ]; then
        GROUP=`get_group $1`
        Echo mkdir -p ${DIR}
             mkdir -p ${DIR}
        Echo chmod 700 ${DIR}
             chmod 700 ${DIR}
        Echo chown $1:${GROUP} ${DIR}
             chown $1:${GROUP} ${DIR}
    fi

    echo ${DIR} > ${TMPFILE}
}

#------------------------------------------------------------------------------
# 鍵ファイルを生成する
# $1:アカウント
# $2:ファイル名
# 戻り値:生成したファイル名
#------------------------------------------------------------------------------
make_sshfile() {

    make_sshdir $1
    DIR=`get_ret`

    TARGET=${DIR}/$2
    if [ ! -f "${TARGET}" ]; then
        GROUP=`get_group $1`
        Echo touch ${TARGET}
             touch ${TARGET}
        Echo chmod 600 ${TARGET}
             chmod 600 ${TARGET}
        Echo chown $1:${GROUP} ${TARGET}
             chown $1:${GROUP} ${TARGET}
    fi

    echo ${TARGET} > ${TMPFILE}
}

#------------------------------------------------------------------------------
# コントローラの鍵を、コントローラに配置する
# $1:コントローラのアカウント
#------------------------------------------------------------------------------
set_key_to_controller() {

    # 鍵ファイルを配置する
    SRC=${KEYDIR}/${CONTROLLER}/$1/${PRIVATE_KEY}

    make_sshfile $1 ${PRIVATE_KEY}
    DEST=`get_ret`

    if [ -s "${DEST}" ]; then
        echo "already exists: ${DEST}"
    else
        Echo cat ${SRC} \>\> ${DEST}
             cat ${SRC} >>   ${DEST}
    fi

    # sshログイン用のコンフィグファイルを配置する
    SRC=${KEYDIR}/${SSH_CONFIG}

    make_sshfile $1 ${SSH_CONFIG}
    DEST=`get_ret`

    if [ -s "${DEST}" ]; then
        echo "already exists: ${DEST}"
    else
        Echo cat ${SRC} \>\> ${DEST}
             cat ${SRC} >>   ${DEST}
    fi
}

#------------------------------------------------------------------------------
# コントローラの鍵を、ノードに配置する
# $1:コントローラのアカウント
#------------------------------------------------------------------------------
set_key_to_node() {

    SRC=${KEYDIR}/${CONTROLLER}/$1/${PUBLIC_KEY}

    make_sshfile ${ANSIBLE_USER} ${AUTH_KEYS}
    DEST=`get_ret`

    # 公開鍵が認証ファイルに未登録なら登録する
    KEY=${1}@${CONTROLLER}
    STATUS=`grep ${KEY} ${DEST}`
    if [ "${STATUS}" = "" ]; then
        Echo cat ${SRC} \>\> ${DEST}
             cat ${SRC} >>   ${DEST}
    else
        echo "already registed: ${KEY}"
    fi
}

#------------------------------------------------------------------------------
# メイン処理
#------------------------------------------------------------------------------

# 鍵ファイルを配置する
RET=1
case "${HOSTNAME}" in
  controller)
    set_key_to_controller root
    set_key_to_controller vagrant
    set_key_to_node root
    set_key_to_node vagrant
    RET=0
    ;;
  node*)
    set_key_to_node root
    set_key_to_node vagrant
    RET=0
    ;;
  *)
    set_key_to_controller root
    set_key_to_controller vagrant
    set_key_to_node root
    set_key_to_node vagrant
    RET=0
    ;;
esac

#exit ${RET}
exit 0
