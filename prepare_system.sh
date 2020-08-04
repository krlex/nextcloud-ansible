#!/bin/bash -uxe
#
# Prepare system for nextcloud devel
#

install_pip () {
        curl https://bootstrap.pypa.io/get-pip.py | $SUDO $PYTHON_BIN
        $SUDO pip3 install setuptools -U
        $SUDO pip3 install ansible -U
        $SUDO pip3 install netaddr -U
        $SUDO pip3 install dnspython -U
        $SUDO pip3 install passlib -U
        $SUDO pip3 install bcrypt -U
}

prepare_ubuntu() {
        $SUDO apt update -y
        $SUDO apt dist-upgrade -y
        $SUDO apt install software-properties-common curl git mc vim facter python3-pip python3-apt aptitude -y
        [ $(uname -m) == "aarch64" ] && $SUDO apt install gcc python3-dev libffi-dev libssl-dev make -y

        PYTHON_BIN=/usr/bin/python3
        install_pip
        $SUDO pip3 install python-apt -U

        set +x
        echo
        echo "   Ubuntu System ready for nextcloud."
        echo
        ansible --version
}

prepare_debian() {
        $SUDO apt update -y
        $SUDO apt dist-upgrade -y
        $SUDO apt install dirmngr curl git mc vim facter python3 python3-pip python3-apt aptitude -y
        [ $(uname -m) == "aarch64" ] && $SUDO apt install gcc python3-dev libffi-dev libssl-dev make -y

        PYTHON_BIN=/usr/bin/python3
        install_pip
        $SUDO pip3 install python-apt -U

        set +x
        echo
        echo "   Debian System ready for nextcloud."
        echo
        ansible --version
}

prepare_raspbian() {
        $SUDO apt update -y
        $SUDO apt dist-upgrade -y
        $SUDO apt install dirmngr mc vim git libffi-dev curl facter -y
        PYTHON_BIN=/usr/bin/python3
        install_pip

        set +x
        echo
        echo "   Rasbpian System ready for nextcloud."
        echo
        ansible --version
}

prepare_centos() {
        $SUDO yum install epel-release -y
        $SUDO yum install git vim mc curl facter libselinux-python python -y
        $SUDO yum update -y

        PYTHON_BIN=/usr/bin/python
        install_pip

        set +x
        echo
        echo "   CentOS System ready for nextcloud."
        echo
        ansible --version
}

prepare_fedora() {
        $SUDO dnf install git vim mc curl facter libselinux-python python python-dnf -y
        $SUDO dnf update -y

        PYTHON_BIN=/usr/bin/python
        install_pip
        $SUDO dnf reinstall python-pip -y

        set +x
        echo
        echo "   Fedora System ready for nextcloud."
        echo
        ansible --version
}

prepare_amzn() {
        $SUDO amazon-linux-extras install epel -y
        $SUDO yum install git vim mc curl facter libselinux-python python -y
        $SUDO yum update -y

        PYTHON_BIN=/usr/bin/python
        install_pip

        set +x
        echo
        echo "   Amazon Linux 2 ready for nextcloud."
        echo
        ansible --version
}

usage() {
        echo
        echo "Linux distribution not detected."
        echo "Use: ID=[ubuntu|debian|centos|raspbian|amzn|fedora] prepare_system.sh"
        echo "Other distributions not yet supported."
        echo
}

if [  -f /etc/os-release ]; then
        . /etc/os-release
elif [ -f /etc/debian_version ]; then
        $ID=debian
fi

# root or not
if [[ $EUID -ne 0 ]]; then
  SUDO='sudo -H'
else
  SUDO=''
fi

case $ID in
        'ubuntu')
                prepare_ubuntu
        ;;
        'debian')
                prepare_debian
        ;;
        'raspbian')
                prepare_raspbian
        ;;
        'centos')
                prepare_centos
        ;;
        'fedora')
                prepare_fedora
        ;;
        'amzn')
                prepare_amzn
        ;;

        *)
                usage
        ;;
esac

