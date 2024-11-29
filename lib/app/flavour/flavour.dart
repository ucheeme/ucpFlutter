class AppFlavorConfig {
  final String name;
  final String apiBaseUrl;
   String? apiGateway;
   String? apiKey;
   String? apiKeyValue;
   String? hmacKey;
   String? hmacKeyData;
   String? aesKey;
   String? aesKeyData;
   String? bankCode;
  AppFlavorConfig({
    required this.name,
    required this.apiBaseUrl,
     this.apiGateway,
     this.apiKey,
     this.apiKeyValue,
     this.hmacKey,
     this.hmacKeyData,
     this.aesKey,
     this.aesKeyData,
     this.bankCode,
  }) ;
}