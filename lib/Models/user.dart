class UserModel {
  final String uid;
  final String name;
  final String phone;
  final bool isOnline;
  final String picture;


  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.isOnline,
    required this.picture
});

  Map<String, dynamic> toMap() {
    return {
      "uid": this.uid,
      "name": this.name,
      "phone": this.phone,
      "isOnline": this.isOnline,
      "picture": this.picture,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      isOnline: map['isOnline'] ?? false,
      picture: map['picture'] ?? '',
    );
  }
}