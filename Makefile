GITHASH=`git log -1 --pretty=format:"%h" || echo "???"`
CURDATE=`date -u +%Y.%m.%d_%H:%M:%S`
VERSION=dev

APPVERSION=${VERSION}_${GITHASH}_${CURDATE}

install:
	mix deps.get
	mix deps.compile

tests:
	mix test

server:
	mix phx.server

run:
	iex -S mix phx.server

clean:
	mix deps.clean --all

docker: install
	make server

up:
	docker-compose up --force-recreate --renew-anon-volumes --remove-orphans

down:
	docker-compose down --volumes --remove-orphans