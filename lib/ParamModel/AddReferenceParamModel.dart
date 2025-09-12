class Reference {
   String? referenceName;
   String? referenceMobile;
   int? referenceRelation;

  Reference({
    this.referenceName,
    this.referenceMobile,
    this.referenceRelation,
  });

  Map<String, dynamic> toJson() {
    return {
      'referenceName': referenceName,
      'referenceMobile': referenceMobile,
      'referenceRelation': referenceRelation,
    };
  }

  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      referenceName: json['referenceName'],
      referenceMobile: json['referenceMobile'],
      referenceRelation: json['referenceRelation'],
    );
  }
}

class AddReferenceParamModel {
   String? custId;
   String? leadId;
   List<Reference>? referenceList;

  AddReferenceParamModel({
    this.custId,
    this.leadId,
    this.referenceList,
  });

  Map<String, dynamic> toJson() {
    return {
      'custId': custId,
      'leadId': leadId,
      'referenceList': referenceList?.map((ref) => ref.toJson()).toList(),
    };
  }

  factory AddReferenceParamModel.fromJson(Map<String, dynamic> json) {
    return AddReferenceParamModel(
      custId: json['custId'],
      leadId: json['leadId'],
      referenceList: (json['referenceList'] as List<dynamic>?)
          ?.map((e) => Reference.fromJson(e))
          .toList(),
    );
  }
}
