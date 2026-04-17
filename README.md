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

### WSL과 현 환경 간 차이
> 디스크 용량 관리
WSL은 VHDX를 추가 마운트하여 디스크 분리 시뮬레이션 가능, 
리얼 리눅스에서는 실제 디스크를 추가해 실제로 디스크 분리를 실시해야 함

(파티션 분리를 해도 되긴 하는데, 현재 `/dev/sda` 자체가 250GB 미만이라 시스템 락다운 위험 큼)

> 가상화 여부에 따른 성능 차이
WSL은 Microsoft Hyper-V상에서 커널을 구동하는 방식으로 성능의 손실 발생, 
리얼 리눅스는 실제 하드웨어상에서 장치 가상화 없이 구동하므로 손실 없음

가상화에 의한 추가 저널 fs가 생성되지 않으나, 보안 부팅 설정이...
- 거기에 `amdgpu.ko`와 `nouveau.ko` 간 충돌이 발생하는 경우 단일 화면 환경에서는 해결이 아얘 불가

> NT SysCall 사용 가능 여부 차이
WSL은 일단 Windows의 서브 시스템이기 때문에 NT 시스템 콜 사용에 제한 없음 (번역 레이어 통과 필수), 
리얼 리눅스는 NT가 뭔지부터 고민해야 할 지경
- 필요한 경우 winehq 설치해오겠습니다...
