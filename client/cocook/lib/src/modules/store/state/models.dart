import 'dart:convert';

class Store {
  Store(this.name);

  final String name;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) {
    return Store.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
