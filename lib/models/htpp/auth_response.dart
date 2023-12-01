import 'dart:convert';

class AuthResponse {
  String status;
  String message;
  UserData data;

  AuthResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AuthResponse.fromJson(String str) =>
      AuthResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        status: json["status"],
        message: json["message"],
        data: UserData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data.toMap(),
      };
}

class UserData {
  User user;
  String token;

  UserData({
    required this.user,
    required this.token,
  });

  factory UserData.fromJson(String str) => UserData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        user: User.fromMap(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "user": user.toMap(),
        "token": token,
      };
}

class User {
  int id;
  String email;
  String firstName;
  String lastName;
  List<Role>? roles;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.roles,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "roles": List<dynamic>.from(roles!.map((x) => x.toMap())),
      };
}

class Role {
  int id;
  String roleName;
  String roleCode;

  Role({
    required this.id,
    required this.roleName,
    required this.roleCode,
  });

  factory Role.fromJson(String str) => Role.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Role.fromMap(Map<String, dynamic> json) => Role(
        id: json["id"],
        roleName: json["roleName"],
        roleCode: json["roleCode"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "roleName": roleName,
        "roleCode": roleCode,
      };
}
