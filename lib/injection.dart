import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'core/logging/app_log.dart';
import 'core/network/api_client.dart';
import 'core/persistence/shared_prefs_store.dart';
import 'features/contacts/data/repositories/contact_repository_impl.dart';
import 'features/contacts/data/services/contact_local_service.dart';
import 'features/contacts/data/services/contact_remote_service.dart';
import 'features/contacts/domain/repositories/contact_repository.dart';
import 'features/contacts/domain/usecases/add_contact_usecase.dart';
import 'features/contacts/domain/usecases/get_contacts_usecase.dart';
import 'features/contacts/domain/usecases/get_recent_contacts_usecase.dart';
import 'features/contacts/domain/usecases/mark_contact_opened_usecase.dart';
import 'features/contacts/domain/usecases/upsert_local_contact_usecase.dart';
import 'features/contacts/presentation/bloc/contacts_bloc.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  AppLog.d('Starting dependency injection setup');

  final sharedPrefsStore = await SharedPrefsStore.create();
  sl.registerSingleton<SharedPrefsStore>(sharedPrefsStore);

  _setupCoreDependencies();
  _setupDataDependencies();
  _setupUseCaseDependencies();
  _setupBlocDependencies();

  AppLog.d('Dependency injection setup complete');
}

void _setupCoreDependencies() {
  sl.registerSingleton<http.Client>(http.Client());
  sl.registerSingleton<ApiClient>(ApiClient(client: sl<http.Client>()));
}

void _setupDataDependencies() {
  sl.registerSingleton<ContactRemoteService>(
    ContactRemoteServiceImpl(apiClient: sl<ApiClient>()),
  );

  sl.registerSingleton<ContactLocalService>(
    ContactLocalServiceImpl(kvStore: sl<SharedPrefsStore>()),
  );

  sl.registerSingleton<ContactRepository>(
    ContactRepositoryImpl(
      remoteService: sl<ContactRemoteService>(),
      localService: sl<ContactLocalService>(),
    ),
  );
}

void _setupUseCaseDependencies() {
  sl.registerSingleton<GetContactsUseCase>(
    GetContactsUseCase(repository: sl<ContactRepository>()),
  );

  sl.registerSingleton<GetRecentContactsUseCase>(
    GetRecentContactsUseCase(repository: sl<ContactRepository>()),
  );

  sl.registerSingleton<MarkContactOpenedUseCase>(
    MarkContactOpenedUseCase(repository: sl<ContactRepository>()),
  );

  sl.registerSingleton<UpsertLocalContactUseCase>(
    UpsertLocalContactUseCase(repository: sl<ContactRepository>()),
  );

  sl.registerSingleton<AddContactUseCase>(
    AddContactUseCase(repository: sl<ContactRepository>()),
  );
}

void _setupBlocDependencies() {
  sl.registerFactory<SplashBloc>(
    () => SplashBloc(prefsStore: sl<SharedPrefsStore>()),
  );

  sl.registerFactory<ContactsBloc>(
    () => ContactsBloc(
      getRecentContactsUseCase: sl<GetRecentContactsUseCase>(),
      markContactOpenedUseCase: sl<MarkContactOpenedUseCase>(),
      addContactUseCase: sl<AddContactUseCase>(),
      repository: sl<ContactRepository>(),
    ),
  );
}
