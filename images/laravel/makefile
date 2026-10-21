build:
	docker build --pull . -t hsmfawaz/laravel:82 --build-arg="PHP_VERSION=8.2"
	docker push hsmfawaz/laravel:82
	docker build --pull . -t hsmfawaz/laravel:81 --build-arg="PHP_VERSION=8.1"
	docker push hsmfawaz/laravel:81
	docker build --pull . -t hsmfawaz/laravel:83 --build-arg="PHP_VERSION=8.3"
	docker push hsmfawaz/laravel:83
	docker build --pull . -t hsmfawaz/laravel:80 --build-arg="PHP_VERSION=8.0"
	docker push hsmfawaz/laravel:80
