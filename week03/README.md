# 3주차
Docker Compose 설정, 계정과 권한

## Docker Compose 설치
**생략**

Docker Community Edition에는 `docker compose` 플러그인이 포함되어 있어, 1.x 버전의 `docker-compose` 패키지를 설치할 필요가 없음

## Docker Compose 설정: `docker-compose.yaml`
- YML (`.yaml`) : JSON을 더 읽기 쉬운 형식으로 작성하기 위해 개발된 슈퍼셋
  * YML 파일 내에 JSON 형식으로 작성도 가능

yaml:
```yaml
services:
  nginx-server:
    image: nginx:1.25-alpine
    container_name: my-web-proxy
    restart: unless-stopped
    ports: [ "80:80" ]
    volumes:
      - ./html:/usr/share/nginx/html
    networks: [ "web-net" ]

networks:
  web-net:
    driver: bridge
```

json: (파일명은 동일하게 `docker-compose.yaml`)
```json
{"services": {
    "nginx-server": {
        "image": "nginx:1.25-alpine",
        "continer_name": "my-web-service",
        "restart": "unless-stopped",
        "ports": [ "80:80" ],
        "volumes": [ "./html:/usr/share/nginx/html" ],
        "networks": [ "web-net" ]
    }
},
"networks": {"web-net": {"driver": "bridge"}}}
```
