#!/bin/bash
current_path=$(pwd)
pkg_name=$1
mkdir -pv ${pkg_name}/ 
mkdir -pv deb_packages/
sudo apt build-dep $pkg_name
if [ $? -ne 0 ]; then
  exit 1
fi
echo -e "\033[35m Building $pkg_name \033[0m"
cd ${pkg_name}
apt source $pkg_name
directory_name=$(ls -d */)
ls 
echo directory is $directory_name
cd $directory_name
DEB_BUILD_OPTIONS='parallel=16 nocheck' fakeroot debian/rules binary
cd ..
ls
echo -e "\033[35m Installing $pkg_name \033[0m"
sudo apt install -y ./*.deb
mv *deb ${current_path}/deb_packages/
cd ${current_path}
sudo rm ${pkg_name} -rf
