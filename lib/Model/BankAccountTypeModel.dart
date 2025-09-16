class BankAccountTypeModel {
  final List<BankAccountTypeParamModel>? data;
  final String? message;
  final int? status;

  BankAccountTypeModel({
    this.data,
    this.message,
    this.status,
  });

  factory BankAccountTypeModel.fromJson(Map<String, dynamic> json) {
    return BankAccountTypeModel(
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => BankAccountTypeParamModel.fromJson(e))
          .toList(),
      message: json['Message'] as String?,
      status: json['Status'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Data': data?.map((e) => e.toJson()).toList(),
      'Message': message,
      'Status': status,
    };
  }
}

class BankAccountTypeParamModel {
   String? bankTypeId;
   String? bankTypeName;

  BankAccountTypeParamModel({
    this.bankTypeId,
    this.bankTypeName,
  });

  factory BankAccountTypeParamModel.fromJson(Map<String, dynamic> json) {
    return BankAccountTypeParamModel(
      bankTypeId: json['bank_type_id'] as String?,
      bankTypeName: json['bank_type_name'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'bank_type_id': bankTypeId,
      'bank_type_name': bankTypeName,
    };
  }

}
class GenderModel {
  final int id;
  final String name;

  GenderModel(this.id, this.name);
}
