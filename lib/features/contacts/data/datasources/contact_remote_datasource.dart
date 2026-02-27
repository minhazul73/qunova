import '../../../../core/constants/api_constants.dart';
import '../../../../core/logging/app_log.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';
import '../models/category_model.dart';
import '../models/contact_model.dart';

/// Remote data source for fetching contacts from the API
class ContactRemoteDataSource {
  final ApiClient _apiClient;

  ContactRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// Fetches contacts and categories from the API
  ///
  /// Returns a tuple containing:
  /// - List of categories
  /// - List of contacts (filtered to exclude empty ones)
  ///
  /// Throws [ApiException] on error
  Future<({List<CategoryModel> categories, List<ContactModel> contacts})>
  fetchContacts() async {
    try {
      AppLog.d('ContactRemoteDataSource: Fetching contacts from API');

      final response = await _apiClient.get(ApiConstants.contactsUrl);

      // Validate response structure
      if (response['status'] != 'success') {
        final message =
            response['message'] as String? ?? 'Unknown error occurred';
        throw ClientException(message);
      }

      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw const ParseException('Missing data field in response');
      }

      // Parse categories
      final categoriesJson = data['categories'] as List<dynamic>?;
      if (categoriesJson == null) {
        throw const ParseException('Missing categories in response');
      }
      final categories = CategoryModel.fromJsonList(categoriesJson);

      // Parse contacts and filter out empty ones
      final contactsJson = data['contacts'] as List<dynamic>?;
      if (contactsJson == null) {
        throw const ParseException('Missing contacts in response');
      }
      final allContacts = ContactModel.fromJsonList(contactsJson);
      final contacts = allContacts
          .where((contact) => !contact.isEmpty)
          .toList();

      AppLog.d(
        'ContactRemoteDataSource: Fetched ${categories.length} '
        'categories and ${contacts.length} contacts (filtered from ${allContacts.length})',
      );

      return (categories: categories, contacts: contacts);
    } on ApiException {
      AppLog.e('ContactRemoteDataSource: API exception occurred');
      rethrow;
    } catch (e) {
      AppLog.e('ContactRemoteDataSource: Unexpected error: $e');
      throw UnknownException(e.toString());
    }
  }
}
