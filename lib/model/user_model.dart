class UserModel{
  String uid ="";
  String fullname = "";
  String email = "";
  String password = "";
  String img_url = "";

  UserModel({required this.fullname, required this.email, required this.password});

  UserModel.fromJson(Map<String,dynamic> json)
    : uid = json['uid'],
      fullname = json['fullname'],
      email = json['email'],
      password = json['password'],
      img_url = json['img_url'];

  Map<String,dynamic> toJson() => {
    "uid" : uid,
    "fullname" : fullname,
    "email" : email,
    "password" : password,
    "img_url" : img_url,
  };
}