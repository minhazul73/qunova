import 'package:equatable/equatable.dart';

/// Domain entity representing a contact category
///
/// Pure business object without JSON serialization logic
class CategoryEntity extends Equatable {
  final String id;
  final String name;

  const CategoryEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() => 'CategoryEntity(id: $id, name: $name)';
}
