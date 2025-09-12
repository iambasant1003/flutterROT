

// const val Uat= 1
// const val PreProd = 1
// const val Prod = 9

class AppConfig {
  static late String baseUrlNode;
  static late String baseUrlPhp;
  static late String authPhpToken;
  static late var appVersion;

  static init(String env) {
    switch (env) {
      case 'dev':
        baseUrlNode = "https://uat-node.loan112fintech.com/journey-service/api/v1/";
        baseUrlPhp = "https://uat-api.loan112fintech.com/";
        authPhpToken = "NWZmYzU2NDVkN2Y3ODIwNDJjZDFhZmViYjA3MTExZDM=";
        appVersion = 1;
        break;
      case 'prod':
        baseUrlNode = "https://node-api.loan112fintech.com/journey-service/api/v1/";
        baseUrlPhp = "https://api.loan112fintech.com/";
        authPhpToken = "NWZmYzU2NDVkN2Y3ODIwNDJjZDFhZmViYjA3MTExZDM=";
        appVersion = 9;
        break;
    }
  }
}
