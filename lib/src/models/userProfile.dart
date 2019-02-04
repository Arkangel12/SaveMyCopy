// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) {
  final jsonData = json.decode(str);
  return UserProfile.fromJson(jsonData);
}

String userProfileToJson(UserProfile data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class UserProfile {
  String name;
  String firstName;
  String lastName;
  String email;
  String photoUrl;
  String id;

  UserProfile({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.photoUrl,
    this.id,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => new UserProfile(
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    photoUrl: json["photoUrl"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "photoUrl": photoUrl,
    "id": id,
  };
}
