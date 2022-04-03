class DropDownQuestionProperties {
  final List<DropDownAnswer> answers;
  final List<DropDownAnswer> allAnswers;
  final bool hasChild;
  final DropDownChildren? principalChild;
  final List<DropDownChildren>? children;
  final bool multiSelect;
  final bool searchable;
  final bool isChild;

  DropDownQuestionProperties(
      {required this.searchable,
      required this.multiSelect,
      required this.answers,
      required this.allAnswers,
      required this.hasChild,
      this.principalChild,
      this.children,
      this.isChild = false});

  Map<String, dynamic> toJson() => {
        "answers": answers.map((e) => e.toJson()),
        "all_answers": allAnswers.map((e) => e.toJson()),
        "has_child": hasChild,
        "principal_child": principalChild?.toJson(),
        "children": children?.map((e) => e.toJson()),
        "is_child": isChild,
        "multi_select": multiSelect,
        "searchable": searchable
      };
}

class DropDownAnswer {
  DropDownAnswer({this.answerId, required this.answer, this.toCompare});

  dynamic answerId;
  String answer;
  String? toCompare;

  factory DropDownAnswer.fromJson(Map<String, dynamic> json) => DropDownAnswer(
      answerId: json["answer_id"],
      answer: json["answer"],
      toCompare: json['to_compare']?.toString());

  Map<String, dynamic> toJson() =>
      {"answer_id": answerId, "answer": answer, "to_compare": toCompare};

  @override
  toString() => answer;
}

class DropDownChildren {
  DropDownChildren({required this.question, required this.section});

  String question;
  String section;

  factory DropDownChildren.fromJson(Map<String, dynamic> json) =>
      DropDownChildren(
          section: json["section_id"], question: json["question_id"]);

  Map<String, dynamic> toJson() =>
      {"section_id": section, "question_id": question};
}
