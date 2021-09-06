class AppConfig {
  static get baseUrl => bool.fromEnvironment('dart.vm.product')
      ? _BASE_URL_PRODUCT
      : _BASE_URL_DEVELOPMENT;
  static const _BASE_URL_DEVELOPMENT = "http://192.168.0.88:5000/";
  static const _BASE_URL_PRODUCT = "http://192.168.0.88:5000/";
}
