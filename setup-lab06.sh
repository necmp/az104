#!/bin/bash

# 開始メッセージ
echo;
printf "\e[33;1m----- NECMP AZ104 Training / Lab06 Setup -----\e[m"
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

# 仮想マシンの作成
echo "仮想マシン" DB$num "を作成します..."
az vm create \
    --resource-group RG$num \
    --name DB$num \
    --image Ubuntu2204 \
    --size Standard_B1ms \
    --admin-username admin$num \
    --admin-password 'Pa$$w0rd1234' \
    --vnet-name VNet$num \
    --subnet Backend \
    --output table

# 仮想マシンの作成
echo "仮想マシン" NVA$num "を作成します..."
az vm create \
    --resource-group RG$num \
    --name NVA$num \
    --image Ubuntu2204 \
    --size Standard_B1ms \
    --admin-username admin$num \
    --admin-password 'Pa$$w0rd1234' \
    --vnet-name VNet$num \
    --subnet DMZ \
    --custom-data ./clouddrive/az104/cloud-init06-nva.txt \
    --output table

# 仮想マシンの作成
echo "仮想マシン" Web$num-B "を作成します..."
az vm create \
    --resource-group RG$num \
    --name Web$num-B \
    --image Ubuntu2204 \
    --size Standard_B1ms \
    --availability-set HA$num \
    --admin-username admin$num \
    --admin-password 'Pa$$w0rd1234' \
    --vnet-name VNet$num \
    --subnet Frontend \
    --custom-data ./clouddrive/az104/cloud-init06-web.txt \
    --output table

# NSGの受信ポートのオープン
echo "仮想マシン" Web$num-B "の受信ポート 80 をオープンします..."
    az vm open-port \
        --resource-group RG$num \
        --name Web$num-B \
        --port 80 \
        --priority 100 \
        --output table
    
# 終了メッセージ
echo;
echo "セットアップが完了しました"
echo;