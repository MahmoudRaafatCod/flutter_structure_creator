import 'dart:io';

void main(List<String> args) {
  String? projectPath;

  if (args.isNotEmpty) {
    projectPath = args[0];
    print('📁 Project path: $projectPath');
  } else {
    print('📁 Enter project path:');
    projectPath = stdin.readLineSync();
  }

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
    bool shouldContinue = createFeature(featuresDir, projectPath);
    if (!shouldContinue) break;
  }
}

bool createFeature(Directory featuresDir, String projectPath) {
  print('✏️  Enter feature name (e.g. home):');
  String? featureName = stdin.readLineSync();

  if (featureName == null || featureName.isEmpty) {
    print('❌ Invalid name!');
    return false;
  }

  if (featureName.endsWith('_screen')) {
    featureName = featureName.substring(0, featureName.length - 7);
  }

  // PascalCase: on_tap -> OnTap
  String className = featureName
      .split('_')
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join();

  // camelCase: on_tap -> onTap
  List<String> parts = featureName.split('_');
  String camelName = parts[0] +
      parts
          .skip(1)
          .map((w) => w[0].toUpperCase() + w.substring(1))
          .join();

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

  print('🎉 Feature "$featureName" structure created successfully!\n');

  // Update routing_names.dart — append only
  File routingNamesFile = File(
    '${featuresDir.parent.path}/core/routing/routing_names.dart',
  );
  if (routingNamesFile.existsSync()) {
    String content = routingNamesFile.readAsStringSync();

    if (content.contains('$camelName(')) {
      print('⚠️  $camelName already exists in routing_names.dart, skipping...');
    } else {
      // Replace the last semicolon-terminated enum entry with entry, newEntry;
      String newEntry = '  $camelName("/$featureName")';
      String updated = content.replaceFirstMapped(
        RegExp(r'(\s+\w+\("[^"]+"\))\s*;'),
        (m) => '${m.group(1)},\n$newEntry;',
      );
      routingNamesFile.writeAsStringSync(updated);
      print('✅ Updated: ${routingNamesFile.path}');
    }
  } else {
    print('⚠️  routing_names.dart not found, skipping...');
  }

  // Update app_router.dart — append only
  String projectName = projectPath.split(RegExp(r'[\\/]')).last;
  File appRouterFile = File(
    '${featuresDir.parent.path}/core/routing/app_router.dart',
  );
  if (appRouterFile.existsSync()) {
    String content = appRouterFile.readAsStringSync();
    String newImport =
        "import 'package:$projectName/features/$featureName/ui/${featureName}_screen.dart';";
    String newCase =
        '      case RoutingNames.$camelName:\n        return MaterialPageRoute(builder: (_) => ${className}Screen());';

    if (content.contains(newImport)) {
      print('⚠️  $camelName already exists in app_router.dart, skipping...');
    } else {
      // Add import before routing_names import
      String updated = content.replaceFirst(
        RegExp(r"import 'package:[^']+/core/routing/routing_names\.dart';"),
        "$newImport\nimport 'package:$projectName/core/routing/routing_names.dart';",
      );
      // Add case before default:
      updated = updated.replaceFirst(
        '      default:',
        '$newCase\n      default:',
      );
      appRouterFile.writeAsStringSync(updated);
      print('✅ Updated: ${appRouterFile.path}');
    }
  } else {
    print('⚠️  app_router.dart not found, skipping...');
  }

  return true;
}
