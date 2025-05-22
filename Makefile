
#python3 -m http.server 8080
#npm install -g http-server
#http-server http-server -p 3000
#cloudflared tunnel --url http://0.0.0.0:8080
run:
    flutter run -d linux

runweb:
    flutter build web

build:
    flutter build web
