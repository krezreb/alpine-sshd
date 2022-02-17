build:
	docker build . -t jbeeson/alpine-sshd

publish: build
	docker push jbeeson/alpine-sshd
