class SavedInstance {
  String? title;
  int? id;
  String? resetDay;

  SavedInstance({
    this.title,
    this.id,
    this.resetDay,
  });

  factory SavedInstance.fromJson(Map<String, dynamic> json) => SavedInstance(
        title: json["title"],
        id: json["id"],
        resetDay: json["resetDay"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "id": id,
        "resetDay": resetDay,
      };
}
