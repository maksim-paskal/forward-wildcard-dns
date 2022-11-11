tag=dev
image=paskalmaksim/forward-wildcard-dns:$(tag)

build:
	docker build --push --push . -t $(image)

run:
	docker kill `docker ps -q`
	docker pull $(image)
	docker run -d \
	-e SERVER_IP=2.2.2.2 \
	-e WILDCARD=".*\.test\.com" \
	-p 127.0.0.2:53:53/udp \
	$(image)

test-resolve:
	dig @127.0.0.2 google.com
	dig @127.0.0.2 google.test.com
