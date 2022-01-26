class UserModel {
  String? uid;
  String? email;
  String? name;

  UserModel({this.email, this.name, this.uid});

  //data from server
  factory UserModel.fromMap(map) {
    return UserModel(uid: map['uid'], name: map['name'], email: map['email']);
  }
  //send data to server
  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email};
  }
}
