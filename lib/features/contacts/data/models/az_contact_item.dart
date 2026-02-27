import 'package:azlistview/azlistview.dart';

import '../../domain/entities/contact_entity.dart';

/// Presentation adapter that maps [ContactEntity] to AzListView contract.
class AzContactItem extends ISuspensionBean {
  final ContactEntity contact;
  final String tag;

  AzContactItem({
    required this.contact,
    required this.tag,
  });

  factory AzContactItem.fromEntity(ContactEntity entity) {
    final name = (entity.name ?? '').trim();
    final firstChar = name.isNotEmpty ? name[0].toUpperCase() : '#';
    final isLetter = RegExp(r'^[A-Z]$').hasMatch(firstChar);

    return AzContactItem(
      contact: entity,
      tag: isLetter ? firstChar : '#',
    );
  }

  String get normalizedName => (contact.name ?? '').trim().toLowerCase();

  @override
  String getSuspensionTag() => tag;
}
