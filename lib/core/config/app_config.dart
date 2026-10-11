/// Build flavors. Must match the native flavor names in `flavorizr.yaml`.
enum Flavor { dev, prod }

/// Per-flavor configuration, injected once at startup from `main_<flavor>.dart`.
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    this.enableNetworkLogs = false,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
  });

  final Flavor flavor;
  final String appName;
  final String baseUrl;
  final bool enableNetworkLogs;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  bool get isDev => flavor == Flavor.dev;
  bool get isProd => flavor == Flavor.prod;

  // TODO(setup): replace the base URLs with your real API hosts.
  // dev points at a public sample API so the example feature works out of the box.
  static const dev = AppConfig(
    flavor: Flavor.dev,
    appName: 'Flutter Foundation Dev',
    baseUrl: 'https://jsonplaceholder.typicode.com',
    enableNetworkLogs: true,
  );

  static const prod = AppConfig(
    flavor: Flavor.prod,
    appName: 'Flutter Foundation',
    baseUrl: 'https://api.example.com',
  );
}
