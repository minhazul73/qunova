import '../../domain/entities/category_entity.dart';

/// Data model for CategoryEntity with JSON serialization
///
/// Extends CategoryEntity (model is a superset)
class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.id, required super.name});

  /// Creates a CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[_Json.id] as String,
      name: json[_Json.name] as String,
    );
  }

  /// Creates a list of CategoryModel from JSON list
  static List<CategoryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Converts this model to JSON
  Map<String, dynamic> get toJson => {_Json.id: id, _Json.name: name};

  @override
  String toString() => 'CategoryModel(id: $id, name: $name)';
}

/// Private class for JSON field names
class _Json {
  static const String id = 'id';
  static const String name = 'name';
}
