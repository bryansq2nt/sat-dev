import 'dart:convert';

import 'package:sat/src/models/form/section_model.dart';

FormModel formModelFromJson(String str) => FormModel.fromJson(json.decode(str));

String formModelToJson(FormModel data) => json.encode(data.toJson());

class FormModel {
  FormModel(
      {required this.formId,
      this.sections = const [],
      this.analyzed = false,
      this.sentToAnalyze = false,
      this.locally = false,
      this.timeOutError = false,
      this.children = const [],
      this.isUpdate = false});

  int formId;
  bool analyzed = false;
  bool sentToAnalyze = false;
  bool locally = false;
  bool isUpdate = false;
  bool timeOutError = false;
  List<SectionModel> sections = [];
  List<FormModel> children = [];

  factory FormModel.fromJson(Map<String, dynamic> json) {
    
    int getId(var id){
      if(id is String){
        return int.parse(id);
      } 
      return id;
    }
    return FormModel(
        formId: getId(json["form_id"]),
        isUpdate: json["isUpdate"] ?? false,
        analyzed: json["analyzed"] ?? false,
        sentToAnalyze: json["sent_to_analyze"] ?? false,
        locally: json["locally"] ?? false,
        sections: json['sections'] != null ? List<SectionModel>.from(json['sections'].map((x) => SectionModel.fromJson(x))) : [],
        children: json['children'] != null ? List<FormModel>.from(
            json['children'].map((x) => FormModel.fromJson(x)))  : []
    );
  }

  Map<String, dynamic> toJson() => {
        "form_id": formId,
        "analyzed": analyzed,
        "sent_to_analyze": sentToAnalyze,
        "locally": locally,
        "sections": sections.map((e) => e.toJson()),
        "children": children.map((e) => e.toJson()),
        "isUpdate": isUpdate
      };

  @override
  toString() =>
      "formId: $formId, sent_to_analyze: $sentToAnalyze, analyzed: $analyzed, locally: $locally, children: $children, sections: $sections";
}

