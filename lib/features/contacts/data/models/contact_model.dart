import '../../domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required super.id,
    required super.isEmpty,
    super.name,
    super.phone,
    super.categoryId,
    super.avatarUrl,
    super.subtitle,
    super.status,
    super.createdAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    final isEmpty = json[_Json.isEmpty] as bool? ?? false;
    final createdAtStr = json[_Json.createdAt] as String?;

    return ContactModel(
      id: json[_Json.id] as String,
      isEmpty: isEmpty,
      name: json[_Json.name] as String?,
      phone: json[_Json.phone] as String?,
      categoryId: json[_Json.categoryId] as String?,
      avatarUrl: json[_Json.avatarUrl] as String?,
      subtitle: json[_Json.subtitle] as String?,
      status: json[_Json.status] as String?,
      createdAt: createdAtStr != null ? DateTime.tryParse(createdAtStr) : null,
    );
  }

  static List<ContactModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => ContactModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Converts this model to JSON
  Map<String, dynamic> get toJson => {
    _Json.id: id,
    _Json.isEmpty: isEmpty,
    _Json.name: name,
    _Json.phone: phone,
    _Json.categoryId: categoryId,
    _Json.avatarUrl: avatarUrl,
    _Json.subtitle: subtitle,
    _Json.status: status,
    _Json.createdAt: createdAt?.toIso8601String(),
  };

  ContactModel copyWith({
    String? id,
    bool? isEmpty,
    String? name,
    String? phone,
    String? categoryId,
    String? avatarUrl,
    String? subtitle,
    String? status,
    DateTime? createdAt,
  }) {
    return ContactModel(
      id: id ?? this.id,
      isEmpty: isEmpty ?? this.isEmpty,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      categoryId: categoryId ?? this.categoryId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      subtitle: subtitle ?? this.subtitle,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ContactModel(id: $id, isEmpty: $isEmpty, name: $name, '
        'phone: $phone, categoryId: $categoryId, status: $status)';
  }
}

/// Private class for JSON field names
class _Json {
  static const String id = 'id';
  static const String isEmpty = 'isEmpty';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String categoryId = 'categoryId';
  static const String avatarUrl = 'avatarUrl';
  static const String subtitle = 'subtitle';
  static const String status = 'status';
  static const String createdAt = 'createdAt';
}
