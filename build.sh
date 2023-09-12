#!/bin/bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DE86F73ED9E67D5E  
echo "deb [arch=amd64] http://debian.kaylordut.com:60001/focal-backports focal-backports main" | sudo tee /etc/apt/sources.list.d/debian-kaylordut.list > /dev/null
sudo apt update
sudo apt install -y python3-apt
mkdir -pv deb_packages
python3 check_package.py
cat update_packages.list
cat update_packages.list | while read pkg_name
do
  if [ -n "$pkg_name" ]; then
    sudo apt build-dep $pkg_name
    echo -e "\033[35m Building $pkg_name \033[0m"
    directory_name=$(apt showsrc $pkg_name | grep orig.tar.xz | grep -m 1 "" | awk '{print $3}' | awk -F '.orig.' '{print $1}' | tr '_' '-')
    echo directory is $directory_name
    apt source $pkg_name
    pwd
    cd $directory_name
    DEB_BUILD_OPTIONS='--parallel' fakeroot debian/rules binary
    cd ..
    mv *deb deb_packages/
    sudo rm ${directory_name}* -rf
    sudo apt install -y ./deb-packages/*.deb
  fi
done