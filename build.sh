#!/bin/bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DE86F73ED9E67D5E  
echo "deb [arch=amd64] http://42.194.233.81:60000/focal-backports focal-backports main" | sudo tee /etc/apt/sources.list.d/debian-kaylordut.list > /dev/null
mv jammy.list /etc/apt/sources.list.d/
sudo apt update
sudo apt install -y python3-apt libncurses5-dev
mkdir -pv deb_packages
python3 check_package.py
cat update_packages.list
echo "Starting................................................................"
cat update_packages.list | while read pkg_name
do
  if [ -n "$pkg_name" ]; then
    sudo apt build-dep $pkg_name
    echo -e "\033[35m Building $pkg_name \033[0m"
    directory_name=$(apt showsrc $pkg_name | grep .orig.tar. | grep -m 1 "" | awk '{print $3}' | awk -F '.orig.' '{print $1}' | tr '_' '-')
    echo directory is $directory_name
    apt source $pkg_name
    ls 
    cd $directory_name
    DEB_BUILD_OPTIONS='--parallel' fakeroot debian/rules binary
    cd ..
    ls
    echo -e "\033[35m Installing $pkg_name \033[0m"
    sudo apt install -y ./*.deb
    mv *deb deb_packages/
    sudo rm ${directory_name}* -rf
  fi
done