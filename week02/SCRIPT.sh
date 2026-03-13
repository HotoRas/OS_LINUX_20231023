#!/bin/bash

# 1. root 사용자 체크: root면 스크립트 종료
if [ "$EUID" -eq 0 ]; then
    return 0 2>/dev/null || exit 0
fi

# 2. 기준 디렉토리 설정 (~/linux)
BASE_DIR="$HOME/linux"

# linux 폴더가 없으면 생성
if [ ! -d "$BASE_DIR" ]; then
    mkdir -p "$BASE_DIR"
fi

# 3. 오늘 날짜 폴더 및 파일명 설정
TODAY=$(date +%Y-%m-%d)
LOG_DIR="$BASE_DIR/$TODAY"
LOG_FILE="$LOG_DIR/${USER}_${TODAY}_session.log"
TIME_FILE="$LOG_DIR/${USER}_${TODAY}_session.tm"  # 타임스탬프 파일 추가

# 4. 오늘 날짜 폴더로 이동 (없으면 생성)
if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
    echo "오늘의 실습 폴더를 생성했습니다: $LOG_DIR"
fi

# 해당 폴더로 이동
cd "$LOG_DIR" || exit

# 5. 무한 루프 방지 및 세션 기록 로직
if [ -z "$UNDER_SCRIPT" ]; then
    # 로그 파일이 이미 존재하고 내용이 있는지 확인
    if [ -s "$LOG_FILE" ]; then
        echo "-----------------------------------------------"
        echo " 알림: 오늘의 로그 파일이 이미 존재합니다."
        echo "-----------------------------------------------"
        tail -n 5 "$LOG_FILE"
        echo "-----------------------------------------------"
    else
        echo "새로운 실습 세션 기록을 시작합니다. (타임스탬프 포함)"
        echo "로그 파일: $LOG_FILE"
        echo "시간 파일: $TIME_FILE"
        
        export UNDER_SCRIPT=1
        
        # -t 옵션으로 타임스탬프를 기록 (Ubuntu 24.04 표준 문법)
        # stderr를 활용하여 타이밍 데이터를 TIME_FILE에 저장합니다.
        script -a -f --timing="$TIME_FILE" "$LOG_FILE"
        
        echo "세션 기록 및 타임스탬프가 저장되었습니다."
        exit
    fi
fi
