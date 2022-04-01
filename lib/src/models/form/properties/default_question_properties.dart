class DefaultQuestionProperties {
  final String hint;
  final bool required = false;
  final int? limit;
  final int maxLines;
  final bool enabled = true;
  final String? mask;
  dynamic answer;

  DefaultQuestionProperties({required this.hint,this.limit,this.maxLines = 1,this.mask, this.answer = ""});
}