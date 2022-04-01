class ProvidedListItem {
  late final int formId;
  String? name;
  String? tipoRelCaso;

  ProvidedListItem({required this.formId, this.name, this.tipoRelCaso});

  ProvidedListItem.fromJson(Map<String, dynamic> json) {
    formId = json['form_id'];
    name = json['name'];
    tipoRelCaso = json['tipo_rel_caso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['form_id'] = formId;
    data['name'] = name;
    data['tipo_rel_caso'] = tipoRelCaso;
    return data;
  }
}