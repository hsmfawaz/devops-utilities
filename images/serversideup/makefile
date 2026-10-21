build:
	@echo "Building 8.2 Slim..."
	docker build --pull . -t hsmfawaz/laravel:82-slim --build-arg="PHP_VERSION=8.2"
	docker push hsmfawaz/laravel:82-slim
	@echo "Building 8.3 Slim..."
	docker build --pull . -t hsmfawaz/laravel:83-slim --build-arg="PHP_VERSION=8.3"
	docker push hsmfawaz/laravel:83-slim