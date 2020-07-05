MAKEFLAGS += -j3

default:
	@echo "Try 'make dev'"

run-signaling-server:
	cd signaling-server && npm run start

run-frame-app:
	cd frame-app && http-server -p 3001

run-remote-app:
	cd remote-app && http-server -p 3002

#dev: run-signaling-server run-frame-app run-remote-app

dev: run-signaling-server
