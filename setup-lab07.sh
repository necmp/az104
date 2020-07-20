#!/bin/bash

# 開始メッセージ
echo;
printf "\e[33;1m----- NECMP AZ104 Training / Lab07 Setup -----\e[m"
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

# リソースグループの作成
echo "リソースグループ" RG$num "を作成します..."
az group create \
  --name RG$num \
  --location japaneast \
  --output table

# 仮想ネットワークの作成
echo "仮想ネットワーク" VNet$num "を作成します..."
az network vnet create \
  --name VNet$num \
  --resource-group RG$num \
  --address-prefixes 10.0.0.0/16 \
  --subnet-name Frontend \
  --subnet-prefixes 10.0.0.0/24 \
  --output table

# 仮想マシンの作成
echo "仮想マシン" Client$num "を作成します..."
az vm create \
    --resource-group RG$num \
    --name Client$num \
    --image UbuntuLTS \
    --size Standard_B1ms \
    --admin-username admin$num \
    --admin-password 'Pa$$w0rd1234' \
    --vnet-name VNet$num \
    --subnet Frontend \
    --output table
    
# 終了メッセージ
echo;
echo "セットアップが完了しました"
echo;