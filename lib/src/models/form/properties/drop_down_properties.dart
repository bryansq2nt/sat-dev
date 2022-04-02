class DropDownQuestionProperties {
  final List<DropDownAnswer> answers;
  final List<DropDownAnswer> answersToShow;
  final bool hasChild;
  final String? principalChild;
  final List<String>? children;
  final bool multiSelect;
  final bool searchable;

  DropDownQuestionProperties(
      {
        required this.searchable,
        required this.multiSelect,
      required this.answers,
      required this.answersToShow,
      required this.hasChild,
      this.principalChild,
      this.children});

  Map<String, dynamic> toJson() => {
        "answers": answers.map((e) => e.toJson()),
        "answersToShow": answersToShow.map((e) => e.toJson()),
        "has_child": hasChild,
        "principal_child": principalChild,
        "children": children,
        "multi_select": multiSelect,
        "searchable":searchable
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
  toString() => "answerId: $answer, answer: $answer, to_compare: $toCompare";
}
