# 2주차
## 기본 리눅스 명령어
- `ls` : 디렉토리 파일 나열 (상세: -l, 숨김 파일 포함: -a)

## 환경 설정을 위한 패키지 설치
- `script` : 화면에 표시되는 STDOUT을 타이밍 파일과 함께 파일로 출력

## Docker Community Edition
- Docker : 리눅스 컨테이너 관리 프로그램
  * 공식 저장소에서 배포중인 버전은 안정성 확인돼 있는 구버전 (Ubuntu)
  * get-docker에서 배포하는 커뮤니티 에디션 배포  
  (설치: `curl -fsSL https://get.docker.com | sudo sh`)
- 설치 후 그룹 설정: `sudo usermod -aG docker $USER`
  * `usermod` : 그룹 조정
  * `-aG <group>[,...]` : 추가할 보조 그룹 목록
  * `$USER` : 실행 호스트 사용자 (`sudo`를 실행하는 사용자) 이름