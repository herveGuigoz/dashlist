import 'dart:convert';

class Store {
  Store(this.name);

  final String name;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) => Store.fromMap(json.decode(source));
}
