enum AppEnvironment { dev, prod }

class EnvironmentConfig {
  static late final AppEnvironment environment;

  static void initialize(AppEnvironment env) {
    environment = env;
  }
}

