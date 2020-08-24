artillerytag ?= artillery:local

.PHONY: help
help:
	@echo "Read the source, luke"

.PHONY: test
test: clean-reports build-artillery run-haproxy-test run-nginx-test

clean-reports:
	rm -rf reports/haproxy.json reports/haproxy.json.html reports/nginx.json reports/nginx.json.html

build-artillery:
	docker build -t $(artillerytag) artillery/

run-nginx-test: nginx-up
	sleep 30
	docker run --rm \
		-v `pwd`/artillery/tests:/tests \
		-v `pwd`/reports:/reports \
		--network=host \
		$(artillerytag) \
		artillery run \
		--config /tests/config/nginx.yml \
		--output /reports/nginx.json \
		/tests/test.yml

run-haproxy-test: haproxy-up
	sleep 30
	docker run --rm \
		-v `pwd`/artillery/tests:/tests \
		-v `pwd`/reports:/reports \
		--network=host \
		$(artillerytag) \
		artillery run \
		--config /tests/config/haproxy.yml \
		--output /reports/haproxy.json \
		/tests/test.yml

nginx-up:
	docker-compose down
	sleep 5
	docker-compose up -d php-fpm nginx

haproxy-up:
	docker-compose down
	sleep 5
	docker-compose up -d php-fpm haproxy

.PHONY: reports
reports: nginx-report haproxy-report

nginx-report:
	docker run --rm \
		-v `pwd`/reports:/reports \
		$(artillerytag) \
		artillery report \
		/reports/nginx.json

haproxy-report:
	docker run --rm \
		-v `pwd`/reports:/reports \
		$(artillerytag) \
		artillery report \
		/reports/haproxy.json
