import 'dart:convert';

Link linkFromJson(String str) {
  final jsonData = json.decode(str);
  return Link.fromJson(jsonData);
}

String linkToJson(Link data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Link {
  String uid;
  String category;
  String url;

  Link({
    this.uid,
    this.category,
    this.url,
  });

  factory Link.fromJson(Map<String, dynamic> json) => new Link(
        uid: json["uid"],
        category: json["category"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "category": category,
        "url": url,
      };
}
