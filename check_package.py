#!/usr/bin/env python3
import argparse
import os
import apt
import copy

def argparse_repos():
    parser = argparse.ArgumentParser()
    parser.add_argument('--cfg',type = str,default=r"packages.list",help="...") # a.yaml中内容在文章开始给出
    args = parser.parse_args()
    filepath = os.path.join(os.getcwd(), args.cfg)
    return filepath

update_packages_list = []

with open(argparse_repos(), 'r') as f:
    cache = apt.Cache()
    for pkg in f:
        pkg = pkg.rstrip()
        try:
            tmp = cache[pkg]
            if tmp.candidate:
                print(pkg + ' is available, skipping')
        except:
            print(pkg + ' is not available, and need to compile')
            update_packages_list.append(pkg)

if len(update_packages_list) > 0:
    with open('update_packages.list', 'w') as f:
        f.write('\n'.join(update_packages_list))


