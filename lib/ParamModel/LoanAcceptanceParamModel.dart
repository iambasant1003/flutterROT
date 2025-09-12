class Loanacceptanceparammodel {
   String? custId;
   String? leadId;
   int? loanAcceptId;
   int? loanAmount;
   int? tenure;
   int? loanPurposeId;

  Loanacceptanceparammodel({
    this.custId,
    this.leadId,
    this.loanAcceptId,
    this.loanAmount,
    this.tenure,
    this.loanPurposeId,
  });

  /// From JSON
  factory Loanacceptanceparammodel.fromJson(Map<String, dynamic> json) {
    return Loanacceptanceparammodel(
      custId: json['custId'] as String?,
      leadId: json['leadId'] as String?,
      loanAcceptId: json['loanAcceptId'] as int?,
      loanAmount: json['loanAmount'] as int?,
      tenure: json['tenure'] as int?,
      loanPurposeId: json['loan_purpose_id'] as int?,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'custId': custId,
      'leadId': leadId,
      'loanAcceptId': loanAcceptId,
      'loanAmount': loanAmount,
      'tenure': tenure,
      'loan_purpose_id': loanPurposeId,
    };
  }
}
