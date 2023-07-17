class UserModel {
  final String userId;
  final String email;
  final String name;
  final String surName;
  final String photoUrl;

  UserModel(
    this.userId,
    this.email,
    this.name,
    this.surName,
    this.photoUrl,
  );

  static Map<String, dynamic> toJson(UserModel user) {
    Map<String, dynamic> userAsMap = {
      'uid': user.userId,
      'email': user.email,
      'name': user.name,
      'surName': user.surName,
      'photoUrl': user.photoUrl,
    };

    return userAsMap;
  }

  factory UserModel.fromJson(Map json) => UserModel(
        json['uid'],
        json['email'],
        json['name'],
        json['surName'],
        json['photoUrl'],
      );
}
