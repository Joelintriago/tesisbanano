
import 'dart:convert';

class RolesPermisos {
  RolesPermisos({
    required this.id,
    required this.roleName,
    required this.roleCode,

  });

  int id;
  String roleName;
  String roleCode;


  factory RolesPermisos.fromJson(String str) => RolesPermisos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RolesPermisos.fromMap(Map<String, dynamic> json) => RolesPermisos(
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