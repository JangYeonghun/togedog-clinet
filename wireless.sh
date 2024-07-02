#!/bin/bash

# ADB 경로 설정
ADB_PATH="/Users/metagaugecorp./Library/Android/sdk/platform-tools/adb"

# 사용자에게 IP:PORT 입력 받기
read -p "Enter IP:PORT for pairing (e.g., 172.30.1.52:46463): " PAIRING_IP_PORT

# 사용자에게 페어링 코드 입력 받기
read -p "Enter pairing code: " PAIRING_CODE

# adb pair 명령어 실행
PAIRING_RESULT=$($ADB_PATH pair $PAIRING_IP_PORT <<< $PAIRING_CODE 2>&1)

# 페어링 성공 메시지 확인
PAIRING_SUCCESS_MSG="Successfully paired to $PAIRING_IP_PORT"

if [[ $PAIRING_RESULT == *"$PAIRING_SUCCESS_MSG"* ]]; then
    echo "Pairing successful."

    # 사용자에게 연결할 IP:PORT 입력 받기
    read -p "Enter IP:PORT for connection (e.g., 172.30.1.52:46415): " CONNECT_IP_PORT

    # adb connect 명령어 실행
    CONNECTION_RESULT=$($ADB_PATH connect $CONNECT_IP_PORT 2>&1)

    # 연결 성공 여부 확인
    if [[ $CONNECTION_RESULT == *"connected to"* ]]; then
        echo "Connection successful."
    else
        echo "Connection failed: $CONNECTION_RESULT"
    fi
else
    echo "Pairing failed. Please check the pairing code and IP:PORT."
    echo "Pairing result: $PAIRING_RESULT"
fi


