import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'core/logging/app_log.dart';
import 'core/network/api_client.dart';
import 'core/persistence/shared_prefs_store.dart';
import 'features/contacts/data/services/contact_local_service.dart';
import 'features/contacts/data/services/contact_remote_service.dart';
import 'features/contacts/data/repositories/contact_repository_impl.dart';
import 'features/contacts/domain/repositories/contact_repository.dart';
import 'features/contacts/domain/usecases/add_contact_usecase.dart';
import 'features/contacts/domain/usecases/get_contacts_usecase.dart';
import 'features/contacts/domain/usecases/get_recent_contacts_usecase.dart';
import 'features/contacts/domain/usecases/mark_contact_opened_usecase.dart';
import 'features/contacts/domain/usecases/upsert_local_contact_usecase.dart';
import 'features/contacts/presentation/bloc/contacts_bloc.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';

/// Service Locator instance
final sl = GetIt.instance;

/// Setup dependency injection for the entire application
///
/// This function registers all dependencies using GetIt service locator.
/// Call this once during app initialization (in main.dart before runApp).
///
/// **IMPORTANT:** This must be called after SharedPreferencesStore is initialized.
/// Use [setupDependencies] in main() which waits for async initialization.
///
/// Dependency Tree:
/// ```
/// ApiClient (singleton)
/// ├─ ContactRemoteDataSource (singleton)
/// │  └─ ContactRepository (singleton)
/// │     ├─ GetContactsUseCase (singleton)
/// │     ├─ GetRecentContactsUseCase (singleton)
/// │     ├─ MarkContactOpenedUseCase (singleton)
/// │     └─ UpsertLocalContactUseCase (singleton)
/// │
/// ├─ SharedPrefsStore (singleton)
/// │  ├─ ContactLocalDataSource (singleton)
/// │  │  └─ ContactRepository (singleton)
/// │  └─ SplashBloc (factory)
/// │
/// └─ Blocs (factory - new instance each time)
///    └─ SplashBloc (factory)
/// ```
void _setupCoreDependencies() {
  AppLog.d('Setting up core dependencies...');

  // ===== Core Layer =====

  // HTTP Client (singleton)
  sl.registerSingleton<http.Client>(http.Client());

  // API Client (singleton)
  sl.registerSingleton<ApiClient>(
    ApiClient(client: sl<http.Client>()),
  );

  AppLog.d('Core dependencies setup complete');
}

void _setupDataDependencies() {
  AppLog.d('Setting up data layer dependencies...');

  // ===== Remote Data Source =====

  // Contact Remote Service (singleton)
  sl.registerSingleton<ContactRemoteService>(
    ContactRemoteServiceImpl(apiClient: sl<ApiClient>()),
  );

  // ===== Local Data Source =====

  // Contact Local Service (singleton)
  sl.registerSingleton<ContactLocalService>(
    ContactLocalServiceImpl(kvStore: sl<SharedPrefsStore>()),
  );

  // ===== Repository =====

  // Contact Repository (singleton)
  // Implements the domain repository interface
  sl.registerSingleton<ContactRepository>(
    ContactRepositoryImpl(
      remoteService: sl<ContactRemoteService>(),
      localService: sl<ContactLocalService>(),
    ),
  );

  AppLog.d('Data layer dependencies setup complete');
}

void _setupUseCaseDependencies() {
  AppLog.d('Setting up use case dependencies...');

  // ===== Use Cases =====

  // Get Contacts Use Case (singleton)
  sl.registerSingleton<GetContactsUseCase>(
    GetContactsUseCase(repository: sl<ContactRepository>()),
  );

  // Get Contacts Use Case (singleton)
  sl.registerSingleton<GetContactsUseCase>(
    GetContactsUseCase(repository: sl<ContactRepository>()),
  );

  // Get Recent Contacts Use Case (singleton)
  sl.registerSingleton<GetRecentContactsUseCase>(
    GetRecentContactsUseCase(repository: sl<ContactRepository>()),
  );

  // Mark Contact Opened Use Case (singleton)
  sl.registerSingleton<MarkContactOpenedUseCase>(
    MarkContactOpenedUseCase(repository: sl<ContactRepository>()),
  );

  // Upsert Local Contact Use Case (singleton)
  sl.registerSingleton<UpsertLocalContactUseCase>(
    UpsertLocalContactUseCase(repository: sl<ContactRepository>()),
  );

  // Add Contact Use Case (singleton)
  sl.registerSingleton<AddContactUseCase>(
    AddContactUseCase(repository: sl<ContactRepository>()),
  );

  AppLog.d('Use case dependencies setup complete');
}

void _setupBlocDependencies() {
  AppLog.d('Setting up bloc dependencies...');

  // ===== Blocs =====

  // Splash Bloc (factory - new instance each time)
  sl.registerFactory<SplashBloc>(
    () => SplashBloc(prefsStore: sl<SharedPrefsStore>()),
  );

  // Contacts Bloc (factory - new instance each time)
  sl.registerFactory<ContactsBloc>(
    () => ContactsBloc(
      getRecentContactsUseCase: sl<GetRecentContactsUseCase>(),
      markContactOpenedUseCase: sl<MarkContactOpenedUseCase>(),
      addContactUseCase: sl<AddContactUseCase>(),
      repository: sl<ContactRepository>(),
    ),
  );

  AppLog.d('Bloc dependencies setup complete');
}

/// Main setup function: initializes SharedPreferences asynchronously, then registers all dependencies
///
/// Call this in main() BEFORE running the app:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await setupDependencies();
///   runApp(const App());
/// }
/// ```
Future<void> setupDependencies() async {
  AppLog.d('===== Starting Dependency Injection Setup =====');

  // Initialize SharedPreferences (must be async)
  AppLog.d('Initializing SharedPreferences...');
  final sharedPrefsStore = await SharedPrefsStore.create();
  sl.registerSingleton<SharedPrefsStore>(sharedPrefsStore);
  AppLog.d('SharedPreferences initialized');

  // Setup in layers
  _setupCoreDependencies();
  _setupDataDependencies();
  _setupUseCaseDependencies();
  _setupBlocDependencies();

  AppLog.d('===== Dependency Injection Setup Complete =====');
}
