get:
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs

get_all:
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs

	cd packages/auth_client && flutter pub get && dart run build_runner build --delete-conflicting-outputs

	cd packages/rest_client && flutter pub get && dart run build_runner build --delete-conflicting-outputs

clean_all_dependencies:
	flutter clean

	cd packages/auth_client && flutter clean

	cd packages/rest_client && flutter clean

coverage:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

watch:
	dart run build_runner watch