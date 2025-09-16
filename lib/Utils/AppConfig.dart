

// const val Uat= 1
// const val PreProd = 1
// const val Prod = 9


// baseUrlNode = "https://node-api.blsfintech.com/journey-service/api/v1/";
// baseUrlPhp = "https://api.blsfintech.com/";

class AppConfig {
  static late String baseUrlNode;
  static late String baseUrlPhp;
  static late String authPhpToken;
  static late var appVersion;

  static init(String env) {
    switch (env) {
      case 'dev':
        baseUrlNode = "https://uat-node.rotfintech.com/journey-service/api/v1/";
        baseUrlPhp = "https://uat-api.rotfintech.com/";
        authPhpToken = "NWZmYzU2NDVkN2Y3ODIwNDJjZDFhZmViYjA3MTExZDM=";
        appVersion = 1;
        break;
      case 'prod':
        baseUrlNode = "https://node-api.rotfintech.com/journey-service/api/v1/";
        baseUrlPhp = "https://api.rotfintech.com/";
        authPhpToken = "NWZmYzU2NDVkN2Y3ODIwNDJjZDFhZmViYjA3MTExZDM=";
        appVersion = 1;
        break;
    }
  }
}
