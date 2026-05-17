# 4주차
사용자와 접근 권한

## 파일 접근 권한
- 권한 구조: RBAC (역할 기반)  
  설정, 출력: `u=rwx,g=rwx,o=rwx` 또는 `0777` (8진수 인코딩)  
  읽기: 4, 쓰기: 2, 실행: 1
  * 최상위 비트: 그룹 권한 공유 지정  
    실행시 권한이 파일의 user: 4  
    실행시 권한이 파일의 group: 2
- 사용자 ID (UID), 그룹 ID (GID): 사용자와 그룹의 내부 아이디 지정 방식
  * `root`: 0
  * 시스템 계정: 1~999, 2000 이상에 큰 수부터
  * 사용자 계정: 1000~1999
- 모든 파일을 root에서 실행하는 것은 보안 취약점  
  -> 사용자를 권한 단위로 파편화

## MOTD (Ubuntu)
> Fedora 환경에서는 MOTD (로그인 셸에서 메시지 표시) 관련 프로그램 혹은 서비스가 없어 구현이 어렵습니다. 필요한 경우 `/etc/profile.d/`에 로드 스크립트를 주입, 구현할 수는 있습니다.

- 경로: `/etc/update-motd.d/`

`/etc/update-motd.d/00-header`: (bash, zsh 기준)
```sh
echo "Welcome to $DISTRIB_DESCRIPTION ($(uname -o) $(uname -r) $(uname -m))"
```
(실제 스크립트는 printf 구문)

* 로그인 스크립트 실행 순서 (bash)
  1. `$HOME/.bash_profile` (로그인 셸에서: `su - <user>`)
    * source `$HOME/.bashrc`
    * 찾지 못하면 `$HOME/.profile`, `/etc/profile` 순서로 추적
  2. `$HOME/.bashrc` (비로그인 셸에서: `su <user> /usr/bin/bash`, `script`)
    * `if [ -d "$HOME/.bashrc.d" ]; then source $HOME/.bashrc.d/*; fi`
    * 찾지 못하면 `/etc/bashrc` 추적
  3. 사용자가 명령 실행
  4. 종료시 클린업: `$HOME/.bash_logout`
    * 찾지 못하면 `/etc/bash_logout` 추적

## 배치 사용자 생성
`create_user.sh`
```sh
#!/bin/bash
for i in {1..20}; do # range: {start..fin}, {item|range,...}
    useradd -m -s /bin/bash "student$i" # 홈 생성, 셸=bash
    echo "student$i:password!" | chpasswd # 비밀번호 지정=password!
    chage -d 0 "student$i" # 비밀번호 변경 강제: 잔여 수명 0일로 지정
fi
```
> 실제 리눅스 설치에서 실행시, Wayland 로그인 환경에서 20개의 로그인 계정이 추가

`team_user.sh`
```sh
#!/bin/bash
for i in {1..5}; do
    sudo usermod -aG dev_team1 "student$i" # 서브 그룹 dev_team1에 추가
done
```
<!--TODO! ACL-->