import 'dart:convert';

class Inventario {
  Inventario({
    required this.id,
    required this.codigo,
    required this.purchaseDate,
    required this.description,
    required this.medida,
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  int id;
  String codigo;
  DateTime purchaseDate;
  String description;
  String medida;
  String product;
  int quantity;
  double unitPrice;

  factory Inventario.fromJson(String str) => Inventario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Inventario.fromMap(Map<String, dynamic> json) => Inventario(
        id: json["id"],
        purchaseDate: DateTime.parse(json["purchaseDate"]),
        codigo: json["codigo"],
        description: json["description"],
        medida: json["medida"],
        product: json["product"],
        quantity: json["quantity"],
        unitPrice: json["unitPrice"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "codigo": codigo,
        "purchaseDate": purchaseDate.toIso8601String(),
        "description": description,
        "medida": medida,
        "product": product,
        "quantity": quantity,
        "unitPrice": unitPrice,
      };
}
