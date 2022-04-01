import 'dart:convert';

enum DependentAnswerType {text,numeric,boolean,date,numericRange,dateRange,containInt,containString,clear}

DependentAnswerModel dependentAnswerModelFromJson(String str) => DependentAnswerModel.fromJson(json.decode(str));

String dependentAnswerModelToJson(DependentAnswerModel data) => json.encode(data.toJson());

class DependentAnswerModel {
  DependentAnswerModel({
    this.type = DependentAnswerType.text,
    this.answer = "",
    this.validated = false
  });
  DependentAnswerType type = DependentAnswerType.text; // field to know what kind of validation we need to do
  dynamic answer = ""; //field to check
  bool validated = false;//field to know if we can show the father of this dependent answer

  factory DependentAnswerModel.fromJson(Map<String, dynamic> json){

    DependentAnswerType _typeFromString = DependentAnswerType.text;
    for(var validType in DependentAnswerType.values){
      if(validType.name == json["type"]){
        _typeFromString =  validType;
      }
    }
    return DependentAnswerModel(
      type: _typeFromString,
      answer: json["answer"],
      validated: json["validated"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type.toString(),
    "answer": answer,
    "validated": validated,
  };


}
