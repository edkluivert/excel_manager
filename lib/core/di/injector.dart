import 'package:excel_manager/core/env/env.dart';
import 'package:excel_manager/data/data_sources/local/hive_db.dart';
import 'package:excel_manager/data/data_sources/local/project_local_ds.dart';
import 'package:excel_manager/data/data_sources/local/task_ds.dart';
import 'package:excel_manager/data/data_sources/remote/mock_api.dart';
import 'package:excel_manager/data/repositories/project_repo_impl.dart';
import 'package:excel_manager/data/repositories/task_repo_impl.dart';
import 'package:excel_manager/domain/repositories/project_repo.dart';
import 'package:excel_manager/domain/repositories/task_repo.dart';
import 'package:excel_manager/services/ai/ai_service.dart';
import 'package:excel_manager/services/ai/mock_ai_service.dart';
import 'package:excel_manager/services/ai/open_ai_service.dart';
import 'package:excel_manager/services/notification/notification_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

Future<void> initInjector() async {
  await HiveDb.init();

  // Data sources
  sl..registerLazySingleton(ProjectLocalDataSource.new)
  ..registerLazySingleton(TaskLocalDataSource.new)
  ..registerLazySingleton(MockApi.new)

  // Repositories
  ..registerLazySingleton<ProjectRepository>(() => ProjectRepositoryImpl(local: sl(), remote: sl()))
  ..registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(local: sl(), remote: sl()))

  ..registerLazySingleton<NotificationService>(NotificationService.new)

  // AI
  ..registerLazySingleton<AiService>(() {
    switch (Env.aiProvider) {
      case AiProvider.openai: return OpenAiService(http.Client());
      case AiProvider.gemini: return MockAiService();
      case AiProvider.mock: _: return MockAiService();
    }
  });
}
