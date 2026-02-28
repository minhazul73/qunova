import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String id;
  final bool isEmpty;
  final String? name;
  final String? phone;
  final String? categoryId;
  final String? avatarUrl;
  final String? subtitle;
  final String? status;
  final DateTime? createdAt;

  const ContactEntity({
    required this.id,
    required this.isEmpty,
    this.name,
    this.phone,
    this.categoryId,
    this.avatarUrl,
    this.subtitle,
    this.status,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    isEmpty,
    name,
    phone,
    categoryId,
    avatarUrl,
    subtitle,
    status,
    createdAt,
  ];

  @override
  String toString() {
    return 'ContactEntity(id: $id, isEmpty: $isEmpty, name: $name, '
        'phone: $phone, categoryId: $categoryId, status: $status)';
  }
}
