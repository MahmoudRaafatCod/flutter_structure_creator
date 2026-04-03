import 'dart:io';

void main() {
  print('📁 Enter project path:');
  String? projectPath = stdin.readLineSync();

  if (projectPath == null || projectPath.isEmpty) {
    print('❌ Invalid path!');
    return;
  }

  Directory featuresDir = Directory('$projectPath/lib/features');
  if (!featuresDir.existsSync()) {
    print('❌ features folder not found!');
    return;
  }

  while (true) {
    createFeature(featuresDir, projectPath);
  }
}

void createFeature(Directory featuresDir, String projectPath) {
  print('✏️  Enter feature name (e.g. home):');
  String? featureName = stdin.readLineSync();

  if (featureName == null || featureName.isEmpty) {
    print('❌ Invalid name!');
    return;
  }

  if (featureName.endsWith('_screen')) {
    featureName = featureName.substring(0, featureName.length - 7);
  }

  List<String> folders = [
    '$featureName/ui',
    '$featureName/ui/widgets',
    '$featureName/data',
    '$featureName/data/models',
    '$featureName/logic',
  ];

  for (String folder in folders) {
    Directory dir = Directory('${featuresDir.path}/$folder');
    dir.createSync(recursive: true);
    print('📂 Created: ${dir.path}');
  }

  String className = featureName
      .split('_')
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join();

  File screenFile = File(
    '${featuresDir.path}/$featureName/ui/${featureName}_screen.dart',
  );
  screenFile.writeAsStringSync('''import 'package:flutter/material.dart';

class ${className}Screen extends StatelessWidget {
  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}''');
  print('✅ Created: ${screenFile.path}');

  File repoFile = File(
    '${featuresDir.path}/$featureName/data/${featureName}_repo.dart',
  );
  repoFile.writeAsStringSync('class ${className}Repo {}');
  print('✅ Created: ${repoFile.path}');

  print('🎉 Feature "$featureName" structure created successfully!');

  // Update routing_names.dart
  File routingNamesFile = File('${featuresDir.parent.path}/core/routing/routing_names.dart');
  if (routingNamesFile.existsSync()) {
    String content = routingNamesFile.readAsStringSync();

    RegExp entryRegex = RegExp(r'\s+(\w+)\("[^"]+"\)[,;]');
    List<String> existing = entryRegex
        .allMatches(content)
        .map((m) => m.group(1)!)
        .toList();

    if (!existing.contains(featureName)) {
      existing.add(featureName);
    }

    StringBuffer entries = StringBuffer();
    for (int i = 0; i < existing.length; i++) {
      String name = existing[i];
      String route = name == 'splash' ? '/' : '/$name';
      bool isLast = i == existing.length - 1;
      entries.writeln('  $name("$route")${isLast ? ';' : ','}');
    }

    String newContent = 'enum RoutingNames {\n${entries}\n  const RoutingNames(String route);\n}\n';
    routingNamesFile.writeAsStringSync(newContent);
    print('✅ Updated: ${routingNamesFile.path}');
  } else {
    print('⚠️  routing_names.dart not found, skipping...');
  }

  // Update app_router.dart
  String projectName = projectPath.split(RegExp(r'[\\/]')).last;
  File appRouterFile = File('${featuresDir.parent.path}/core/routing/app_router.dart');
  if (appRouterFile.existsSync()) {
    String content = appRouterFile.readAsStringSync();

    RegExp importRegex = RegExp(r"import 'package:[^/]+/features/(\w+)/ui/\w+\.dart';");
    List<String> existingFeatures = importRegex
        .allMatches(content)
        .map((m) => m.group(1)!)
        .toList();

    if (!existingFeatures.contains(featureName)) {
      existingFeatures.add(featureName);
    }

    String imports = existingFeatures
        .map((f) => "import 'package:$projectName/features/$f/ui/${f}_screen.dart';")
        .join('\n');

    String cases = existingFeatures
        .map((f) {
          String cls = f.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join();
          return '      case RoutingNames.$f.route:\n        return MaterialPageRoute(builder: (_) => ${cls}Screen());';
        })
        .join('\n');

    String newContent = """import 'package:flutter/material.dart';
$imports
import 'package:$projectName/core/routing/routing_names.dart';

class AppRouter {
    static Route onGenerateRoute(RouteSettings settings){
    switch(settings.name){
$cases
      default:
        return MaterialPageRoute(builder: (_) => Scaffold());
    }
  }
}""";

    appRouterFile.writeAsStringSync(newContent);
    print('✅ Updated: ${appRouterFile.path}');
  } else {
    print('⚠️  app_router.dart not found, skipping...');
  }
}
