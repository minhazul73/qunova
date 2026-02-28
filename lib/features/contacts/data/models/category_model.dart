import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.id, required super.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[_Json.id] as String,
      name: json[_Json.name] as String,
    );
  }

  static List<CategoryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> get toJson => {_Json.id: id, _Json.name: name};

  @override
  String toString() => 'CategoryModel(id: $id, name: $name)';
}

/// Private class for JSON field names
class _Json {
  static const String id = 'id';
  static const String name = 'name';
}
