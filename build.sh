#!/bin/env bash

set -e

if ! command -v conan &> /dev/null; then
    echo "Conan is not installed" && exit 1
fi

# 保证子模块初始化
git submodule update --init --recursive

# 安装依赖
conan export UmaPyogin
conan install conanfile.txt -pr theos.profile -s os.version=13.0 -if build --build missing

# 复制本地化数据
mkdir -p "layout/var/mobile/Library/Application Support/UmaPyogin/hash_dicts"
find Trainers-Legend-G-TRANS/localized_data -maxdepth 1 -name "*.json" -not -name "static.json" | xargs cp -t "layout/var/mobile/Library/Application Support/UmaPyogin/hash_dicts"

cp Trainers-Legend-G-TRANS/localized_data/static.json "layout/var/mobile/Library/Application Support/UmaPyogin/"

cp -r Trainers-Legend-G-TRANS/localized_data/stories "layout/var/mobile/Library/Application Support/UmaPyogin"

# 构建！
make package FINALPACKAGE=1
