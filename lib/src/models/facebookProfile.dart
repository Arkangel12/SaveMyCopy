// To parse this JSON data, do
//
//     final facebookProfile = facebookProfileFromJson(jsonString);

import 'dart:convert';

FacebookProfile facebookProfileFromJson(String str) {
  final jsonData = json.decode(str);
  return FacebookProfile.fromJson(jsonData);
}

String facebookProfileToJson(FacebookProfile data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class FacebookProfile {
  String name;
  String firstName;
  String lastName;
  String email;
  String id;

  FacebookProfile({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.id,
  });

  factory FacebookProfile.fromJson(Map<String, dynamic> json) => new FacebookProfile(
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "id": id,
  };
}
