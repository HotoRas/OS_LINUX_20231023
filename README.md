# 운영체제 실습 레포지트리
202231023 전도현

> 환경 상이 : real linux Fedora 43 w/ KDE Desktop

Environment:
- cpu0 : AMD Radeon 5 7535HS
- gpu0 : AMD Radeon HD Graphics
- gpu1 : NVIDIA GeForce RTX 2060
- ram  : 16GB (4GB zram)
- sda  : USB SATA SSD 240GB
- nvme0n1 : Windows installation
- DE   : KDE Plasma
- IME  : fcitx5

> 이하 : weekly mockup

> TODO! 주차별 내용 분리 및 상세화

## 2주차
- Docker CE 설치
- Docker 컨테이너 실행, 이미지 관리
- `docker run` 명령에서 외부 경로 연동

## 3주차
- 사용자 생성, 배치 생성
- `docker compose`를 통한 Docker 이미지 관리

## 4주차
- 사용자에 그룹 추가, 배치 추가
- 디렉토리에 소유권 부여
  * `r` : `1 << 2` : 읽기
  * `w` : `1 << 1` : 쓰기
  * `x` : `1`      : 실행
- 디렉토리에 ACL 부여
  * `u:$USER:rwx?` : 사용자에 부여
  * `g:$GROUP:rwx?` : 그룹에 부여

### 사후 작업
- `student{6..20}`의 사용자 데이터 삭제, `/home/student{6..20}` 삭제

## 5주차
- 프로세스 관리 (`top`, `htop`)
- 프로세스 생성
  * 생성 및 관리, nice
  * Docker 내부 좀비 프로세스 생성
    > 컨테이너 내부 좀비 프로세스는 컨테이너 외부에서 pkill 불가

## 6주차
- 프로세스 관리 (`limits`)
  * 사용자별 수준 프로세스 수 제한
  * 프로세스 수 상한 도달시 추가 프로세스 생성 불가, soft 상한 확장 불가 (NOT `/bin/bash`)

### 사후 작업
- Docker 프로세스 자체에 nice 적용 가능여부 불분명
  * is docker running not under root? -> yes

## 7주차
- 파일시스템 확인
  * `fs=none,type=overlay` : WSL2 저널링 환경
  * `fs=NTDRIVEALIAS,type=9p` : WSU NT 저널링 터널 프로토콜
  * 리얼 리눅스에서는 이상의 fs가 표시되지 않음
  * 리얼 리눅스: NTFS를 ntfs로 마운트 (ro)<br>ntfs-3g로 해도 되긴 하는데 굳이?
- fdisk, ext4 저널링 시스템 기본
  * `if (!(file->links.size())) free(file);`
  * hard link : inode에 링크 추가
  * symlink   : 링크를 가리키는 링크 추가
- docker overlayfs
  * 위치 : `/var/lib/docker`
  * 구현 : fuseblk
  * 로그 : 길다 많다 너무많다

## 9주차
- 가상 디스크 파일 생성 및 장치 설정
  * `losetup -fP <path-to-file>`
    - WSL에서는 휘발성이지만, 리얼 리눅스에서는 자동 마운트 가능 확인
  * `pvcreate /dev/$DEVICE`
  * `vgcreate <vg_name> /dev/$DEVICE`
  * `lvcreate -l <size|$pcnt%FREE> -n <lv_name> <vg_name>`
  * `mkfs.$FORMAT <path-to-device>`
- 메타데이터 유지 복사 (`rcync -aHAX <from> <to>`)

### 사후 작업
- **물리 디스크 이전 (250G SSD -> 500G SSD)**
  * 실제 리눅스 재설치 및 `/home` rsync를 통한 보존
  * `/var/lib` 디렉토리 분리로 docker 이하에 충분한 용량 제공
  
## 10주차
> 새 디스크에서 작업 진행하며, 가상 입력기 설치 이전에 작업한 관계로 파일 내 주석이 없습니다
- `.gitignore` 수정: `.../week10/wordpress/.gitignore` 생성 처리
- nginx:`default.conf`: 줄 수 최소화 (`location /` 블록을 한 줄로 쓴다던지)
- docker compose:`config.{db,wordpress,nginx}.yaml`: 바이트 최적화를 위해 부분적인 JSON 문법 활용
  * `key:\n\t- value\n\t- value` = `key: ["value","value"]`
  * `key:\n\texternal: false` = `key: {"external": false}`
  * JSON 파서보다 YAML 파서가 조금 더 forgiving함 (`"key": value`에서 JSON 파서는 `value` 선행 공백 요구, YAML은 불필요)
- WordPress: 최초 설치 완료

> setup_docker.sh:
> - 디렉토리를 동일한 sdX 상에서 제공하여, 별도의 losetup 및 docker compose 재시작 불필요
> - systemctl의 docker.service 시작과 동시에 이상 없이 시작되는 것을 확인
> - 리얼 리눅스의 경우 마운트에 실패하더라도 디렉토리 접근은 가능, docker.service 자체는 정상 실행에 성공하므로<br>이를 스크립트화하여 적용하려면 해당 스크립트를 systemd에 등록 후 docker의 wandtd-by에 해당 서비스를 추가해야 함
>   * 스크립트의 wandtd-by: multi-user.target
>   * 스크립트의 서비스명이 `init-vdisk.service`일 때 `docker.service`의 wanted-by: multi-user.target, init-vdisk.target
>   * 이때 스크립트에는 docker 관련 명령어가 없어야 함

