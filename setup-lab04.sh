#!/bin/bash

# 開始メッセージ
echo;
printf "\e[33;1m----- NECMP AZ104 Training / Lab04 Setup -----\e[m"
echo;
echo;
echo -n "あなたの <受講者番号> を入力してください = "
read num
echo;
echo "あなたが入力した <受講者番号> は" $num "です"
echo -n "セットアップを開始してよろしいですか？(y/n) = "
read yesno
case "$yesno" in [yY]*) ;; *) echo "終了します" ; exit ;; esac
echo;

# 可用性セットの作成
echo "可用性セット" HA$num "を作成します..."
az vm availability-set create \
    --resource-group RG$num \
    --name HA$num \
    --platform-fault-domain-count 2 \
    --platform-update-domain-count 5 \
    --output table

# 仮想マシンの作成
echo "仮想マシン" Web$num-A "を作成します..."
az vm create \
    --resource-group RG$num \
    --name Web$num-A \
    --image UbuntuLTS \
    --availability-set HA$num \
    --size Standard_B1ms \
    --admin-username admin$num \
    --admin-password 'Pa$$w0rd1234' \
    --vnet-name VNet$num \
    --subnet Frontend \
    --custom-data cloud-init04.txt \
    --output table

# 終了メッセージ
echo;
echo "セットアップが完了しました"
echo;