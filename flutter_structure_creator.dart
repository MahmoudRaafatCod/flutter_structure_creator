import 'dart:io';

void main() {
  createFlutterStructure();
}

void createFlutterStructure() {
  // طلب مسار المجلد الأب
  print('📁 Enter the path to the folder where the project will be created:');
  String? parentPath = stdin.readLineSync();

  if (parentPath == null || parentPath.isEmpty) {
    print('❌ Invalid path!');
    return;
  }

  // طلب اسم المشروع
  print('✏️  Enter the project name:');
  String? projectName = stdin.readLineSync();

  if (projectName == null || projectName.isEmpty) {
    print('❌ Invalid project name!');
    return;
  }

  print('📦 Are there any external files? (y/n):');
  String? hasAssets = stdin.readLineSync();
  bool includeAssets = hasAssets?.toLowerCase() == 'y';

  print('🌐 Is there an API DIO? (y/n):');
  String? hasDio = stdin.readLineSync();
  bool inCludeDio = hasDio?.toLowerCase() == 'y';

  // تنفيذ flutter create
  print('🚀 Creating Flutter project...');
  ProcessResult createResult = Process.runSync('cmd', [
    '/c',
    'flutter',
    'create',
    projectName,
  ], workingDirectory: parentPath);

  if (createResult.exitCode != 0) {
    print('❌ Failed to create project: ${createResult.stderr}');
    return;
  }

  print('✅ Project created successfully!');

  String projectPath = '$parentPath/$projectName';

  // التحقق من وجود مجلد lib
  Directory libDir = Directory('$projectPath/lib');

  if (!libDir.existsSync()) {
    print('❌ lib folder not found!');
    return;
  }

  // إنشاء هيكل المجلدات
  List<String> folders = [
    'core/routing',
    'core/dependency_injection',
    'core/network',
    'core/theming',
    'core/utils/constants',
    'core/utils/observers',
    'core/shared/widgets',
    'core/shared/models',
    if (inCludeDio) 'core/exceptions',
    'features/home/ui',
    'features/home/ui/widgets',
    'features/home/data',
    'features/home/data/models',
    'features/home/logic',
  ];

  for (String folder in folders) {
    Directory dir = Directory('${libDir.path}/$folder');
    dir.createSync(recursive: true);
    print('📂 Created: ${dir.path}');
  }

  // إنشاء مجلدات assets خارج lib
  if (includeAssets) {
    List<String> assetsFolders = [
      'assets/fonts',
      'assets/icons',
      'assets/images',
      'assets/jsons',
      'assets/translations',
    ];

    for (String folder in assetsFolders) {
      Directory dir = Directory('$projectPath/$folder');
      dir.createSync(recursive: true);
      print('📂 Created: ${dir.path}');
    }
  }

  // ===========================================
  // pubspec

  // تعديل ملف pubspec.yaml
  if (includeAssets) {
    File pubspecFile = File('$projectPath/pubspec.yaml');
    if (pubspecFile.existsSync()) {
      String pubspecContent = pubspecFile.readAsStringSync();
      pubspecContent = pubspecContent.replaceAll(
        RegExp(
          r'  # assets:\s*\n  #   - images/a_dot_burr\.jpeg\s*\n  #   - images/a_dot_ham\.jpeg',
        ),
        '  assets:\n    - assets/images/\n    - assets/icons/\n    - assets/fonts/\n    - assets/jsons/\n    - assets/translations/',
      );
      pubspecFile.writeAsStringSync(pubspecContent);
      print('✅ Updated: ${pubspecFile.path}');
    }
  }

  // حذف main.dart الموجود وإنشاء جديد
  File mainFile = File('${libDir.path}/main.dart');
  if (mainFile.existsSync()) {
    mainFile.deleteSync();
    print('🗑️  Deleted old main.dart');
  }

  // تحويل اسم المشروع إلى PascalCase للكلاس
  List<String> words = projectName.split('_');
  String pascalName = words
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join();
  bool endsWithApp = words.last.toLowerCase() == 'app';
  String className = endsWithApp ? pascalName : '${pascalName}App';
  String fileName = endsWithApp ? projectName : '${projectName}_app';

  String mainContent =
      '''import 'package:flutter/material.dart';
      import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$projectName/core/dependency_injection/dependency_injection.dart';
import 'package:$projectName/core/utils/observers/states_observer.dart';
import 'package:$projectName/$fileName.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
  Bloc.observer = StatesObserver();
  runApp($className());
}''';

  mainFile.writeAsStringSync(mainContent);
  print('✅ Created: ${mainFile.path}');

  // إنشاء ملف app
  String myAppContent =
      '''import 'package:$projectName/core/routing/app_router.dart';
import 'package:flutter/material.dart';

class $className extends StatelessWidget {
  const $className({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "$projectName", onGenerateRoute: AppRouter.onGenerateRoute,);
  }
}''';

  File myAppFile = File('${libDir.path}/$fileName.dart');
  myAppFile.writeAsStringSync(myAppContent);
  print('✅ Created: ${myAppFile.path}');

  String routeNamesContent = '''enum RoutingNames {
  home("/"),

  final String route;
  const RoutingNames(this.route);

  static RoutingNames? fromRoute(String? route) {
    return RoutingNames.values.firstWhere(
          (e) => e.route == route,
      orElse: () => RoutingNames.splash,
    );
  }
}
    ''';

  // إنشاء ملف route_names.dart
  File routeNamesFile = File('${libDir.path}/core/routing/routing_names.dart');
  routeNamesFile.writeAsStringSync(routeNamesContent);
  print('✅ Created: ${routeNamesFile.path}');

  // إنشاء ملف routing.dart
  String routingContent =
      '''import 'package:flutter/material.dart';
import 'package:$projectName/features/home/ui/home_screen.dart';
import 'package:$projectName/core/routing/routing_names.dart';

class AppRouter {
    static Route onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case RoutingNames.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => Scaffold());
    }
  }
}''';

  File routingFile = File('${libDir.path}/core/routing/app_router.dart');
  routingFile.writeAsStringSync(routingContent);
  print('✅ Created: ${routingFile.path}');

  print('🎉 Folder and file structure created successfully!');

  // ===========================================
  // إنشاء ملف home_screen.dart
  String homeScreenContent = '''import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}''';

  // home_screen
  File homeScreenFile = File(
    '${libDir.path}/features/home/ui/home_screen.dart',
  );
  homeScreenFile.writeAsStringSync(homeScreenContent);
  print('✅ Created: ${homeScreenFile.path}');

  // ===========================================
  // home_repo

  //   String homeRepoContent = '''import 'package:dio/dio.dart';
  // import 'package:test44/core/network/api_consumer.dart';

  // class HomeRepo {
  //   final ApiConsumer apiConsumer;

  //   HomeRepo(this.apiConsumer);
  // }''';

  // home_repo
  File homeRepoFile = File('${libDir.path}/features/home/data/home_repo.dart');
  homeRepoFile.writeAsStringSync('class HomeRepo {}');
  print('✅ Created: ${homeRepoFile.path}');

  // ===========================================
  // dependency_injection

  if (inCludeDio) {
    String dependencyInjectionContent =
        '''import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:$projectName/core/network/api_consumer.dart';
import 'package:$projectName/core/network/dio_consumer.dart';

  class DependencyInjection {
    DependencyInjection._();

    static final GetIt getIt = GetIt.instance;

    static Future<void> init() async {
     /// Dio Consumer
    getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(Dio()));

    /// Repos
    /// getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt<ApiConsumer>()));

    /// Cubits
    }
  }

      ''';
    File dependencyInjectionFile = File(
      '${libDir.path}/core/dependency_injection/dependency_injection.dart',
    );
    dependencyInjectionFile.writeAsStringSync(dependencyInjectionContent);
    print('✅ Created: ${dependencyInjectionFile.path}');
  } else {
    String dependencyInjectionContent = '''import 'package:get_it/get_it.dart';

  class DependencyInjection {
    DependencyInjection._();

    static final GetIt getIt = GetIt.instance;

    static Future<void> init() async {}
  }

      ''';
    File dependencyInjectionFile = File(
      '${libDir.path}/core/dependency_injection/dependency_injection.dart',
    );
    dependencyInjectionFile.writeAsStringSync(dependencyInjectionContent);
    print('✅ Created: ${dependencyInjectionFile.path}');
  }

  //=====================================
  // resources

  String responseResultContent = '''
  abstract class ResponseResult<T> {
    ResponseResult();
  }

  class SuccessResponse<T> extends ResponseResult<T> {
    final T data;

    SuccessResponse(this.data);
  }

  class FailureResponse<T> extends ResponseResult<T> {
    final String message;

    FailureResponse(this.message);
  }

  ''';

  File resourcesFile = File('${libDir.path}/core/network/response_result.dart');
  resourcesFile.writeAsStringSync(responseResultContent);
  print('✅ Created: ${resourcesFile.path}');

  // =======================================
  // theme

  File themeFile = File('${libDir.path}/core/theming/theming_colors.dart');
  themeFile.writeAsStringSync('class ThemingColors {ThemingColors._();}');
  print('✅ Created: ${themeFile.path}');

  File themeFileFont = File(
    '${libDir.path}/core/theming/theming_font_styles.dart',
  );
  themeFileFont.writeAsStringSync(
    'class ThemingFontStyles {ThemingFontStyles._();}',
  );
  print('✅ Created: ${themeFileFont.path}');

  // ===========================================
  // utils constants

  File utilsConstantsIconFile = File(
    '${libDir.path}/core/utils/constants/constant_icons.dart',
  );
  utilsConstantsIconFile.writeAsStringSync('''class ConstantIcons {
  ConstantIcons._();

  static const String base = "assets/icons";
}''');
  print('✅ Created: ${utilsConstantsIconFile.path}');

  File utilsConstantsImagesFile = File(
    '${libDir.path}/core/utils/constants/constant_images.dart',
  );
  utilsConstantsImagesFile.writeAsStringSync('''class ConstantImages {
  ConstantImages._();

  static const String base = "assets/icons";
}''');
  print('✅ Created: ${utilsConstantsImagesFile.path}');

  File utilsConstantsStringsFile = File(
    '${libDir.path}/core/utils/constants/constant_strings.dart',
  );
  utilsConstantsStringsFile.writeAsStringSync('''class ConstantStrings {
  ConstantStrings._();
}''');
  print('✅ Created: ${utilsConstantsStringsFile.path}');

  File utilsConstantsValidatorsFile = File(
    '${libDir.path}/core/utils/constants/constant_validators.dart',
  );
  utilsConstantsValidatorsFile.writeAsStringSync('''class ConstantValidators {
  ConstantValidators._();
}''');
  print('✅ Created: ${utilsConstantsValidatorsFile.path}');

  // ===========================================
  // utils observer

  String utilsObserverContent = r'''import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatesObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    debugPrint("🆕 Created ${bloc.runtimeType}");
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint("📢 Event: $event in ${bloc.runtimeType}");
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint("🔄 State Change in ${bloc.runtimeType}: $change");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint("➡️ Transition in ${bloc.runtimeType}: $transition");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint("💥 Error in ${bloc.runtimeType}: $error");
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugPrint("❌ Closed ${bloc.runtimeType}");
  }
}
''';

  File utilsObserverFile = File(
    '${libDir.path}/core/utils/observers/states_observer.dart',
  );
  utilsObserverFile.writeAsStringSync(utilsObserverContent);
  print('✅ Created: ${utilsObserverFile.path}');

  // ===========================================
  // exceptions

  if (inCludeDio) {
    String dioContent = '''class ExceptionModel {
  final bool success;
  final String message;

  ExceptionModel({required this.success, required this.message});

  factory ExceptionModel.fromJson(Map<String, dynamic> json){
    return ExceptionModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "Unknown Error",
    );
  }
}

    ''';

    File dioFile = File('${libDir.path}/core/exceptions/exception_model.dart');
    dioFile.writeAsStringSync(dioContent);
    print('✅ Created: ${dioFile.path}');
  }

  // ===========================================

  if (inCludeDio) {
    String dioContent =
        '''import 'package:dio/dio.dart';
import 'package:${projectName}/core/exceptions/exception_model.dart';


class ExceptionsHandler {
  static void dioExceptionsHandler(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        throw ExceptionModel.fromJson(exception.response!.data);
      case DioExceptionType.sendTimeout:
        throw ExceptionModel.fromJson(exception.response!.data);
      case DioExceptionType.receiveTimeout:
        throw ExceptionModel.fromJson(exception.response!.data);
      case DioExceptionType.badCertificate:
        throw ExceptionModel.fromJson(exception.response!.data);
      case DioExceptionType.cancel:
        throw ExceptionModel.fromJson(exception.response!.data);
      case DioExceptionType.connectionError:
        throw ExceptionModel.fromJson(exception.response!.data);
      case DioExceptionType.unknown:
        throw ExceptionModel.fromJson(exception.response!.data);
      case DioExceptionType.badResponse:
        switch (exception.response?.statusCode) {
          case 400:
            throw ExceptionModel.fromJson(exception.response!.data);
          case 401:
            throw ExceptionModel.fromJson(exception.response!.data);
          case 403:
            throw ExceptionModel.fromJson(exception.response!.data);
          case 404:
            throw ExceptionModel.fromJson(exception.response!.data);
          case 409:
            throw ExceptionModel.fromJson(exception.response!.data);
          case 422:
            throw ExceptionModel.fromJson(exception.response!.data);
          case 504:
            throw ExceptionModel.fromJson(exception.response!.data);
        }
    }
  }
}

    ''';

    File dioFile = File(
      '${libDir.path}/core/exceptions/exceptions_handler.dart',
    );
    dioFile.writeAsStringSync(dioContent);
    print('✅ Created: ${dioFile.path}');
  }

  // ===========================================

  if (inCludeDio) {
    String dioApiConsumer = r'''abstract class ApiConsumer {
  Future get(String path, {dynamic data, Map<String, dynamic>? queryParams});

  Future put(String path, {dynamic data, Map<String, dynamic>? queryParams, bool isFormData = false});

  Future post(String path, {dynamic data, Map<String, dynamic>? queryParams, bool isFormData = false});

  Future patch(String path, {dynamic data, Map<String, dynamic>? queryParams, bool isFormData = false});

  Future delete(String path, {dynamic data, Map<String, dynamic>? queryParams, bool isFormData = false});
}
  ''';

    File dioFile = File('${libDir.path}/core/network/api_consumer.dart');
    dioFile.writeAsStringSync(dioApiConsumer);
    print('✅ Created: ${dioFile.path}');
  }

  // ===========================================
  if (inCludeDio) {
    String dioConsumer =
        '''import 'package:dio/dio.dart';
import 'package:${projectName}/core/exceptions/exceptions_handler.dart';
import 'package:${projectName}/core/network/api_consumer.dart';

class DioConsumer extends ApiConsumer {
  final Dio _dio;

  DioConsumer(this._dio) {
    _dio.options.baseUrl = "https://test.com";
    //   _dio.options.headers = {
    //     "Authorization": dotenv.env['API_TOKEN'],
    //     "accept": "application/json",};
    //   // _dio.interceptors.add(LogInterceptor(request: true, requestHeader: true, responseHeader: true, requestBody: true, responseBody: true));
  }

  @override
  Future get(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      Response response = await _dio.get(
        path,
        data: data,
        queryParameters: queryParams,
      );
      return response.data;
    } on DioException catch (exception) {
      ExceptionsHandler.dioExceptionsHandler(exception);
    }
  }

  @override
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    bool isFormData = false,
  }) async {
    try {
      Response response = await _dio.put(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParams,
      );
      return response.data;
    } on DioException catch (exception) {
      ExceptionsHandler.dioExceptionsHandler(exception);
    }
  }

  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    bool isFormData = false,
  }) async {
    try {
      Response response = await _dio.post(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParams,
      );
      return response.data;
    } on DioException catch (exception) {
      ExceptionsHandler.dioExceptionsHandler(exception);
    }
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    bool isFormData = false,
  }) async {
    try {
      Response response = await _dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParams,
      );
      return response.data;
    } on DioException catch (exception) {
      ExceptionsHandler.dioExceptionsHandler(exception);
    }
  }

  @override
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    bool isFormData = false,
  }) async {
    try {
      Response response = await _dio.delete(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParams,
      );
      return response.data;
    } on DioException catch (exception) {
      ExceptionsHandler.dioExceptionsHandler(exception);
    }
  }
}

  ''';

    File dioFile = File('${libDir.path}/core/network/dio_consumer.dart');
    dioFile.writeAsStringSync(dioConsumer);
    print('✅ Created: ${dioFile.path}');
  }

  // تنفيذ الأوامر
  for (var cmd in [
    if (inCludeDio) ['dio'],
    ['flutter_bloc'],
    ['get_it'],
  ]) {
    print('⏳ Running: flutter pub add ${cmd[0]} ...');
    Process.runSync('cmd', [
      '/c',
      'flutter',
      'pub',
      'add',
      ...cmd,
    ], workingDirectory: projectPath);
    print('✅ Done: flutter pub add ${cmd[0]}');
  }
  print('🎉 All done! Project "$projectName" is ready.');
}
