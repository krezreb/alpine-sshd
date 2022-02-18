build:
	docker pull alpine:latest
	docker build . -t jbeeson/alpine-sshd

publish: build
	docker push jbeeson/alpine-sshd
