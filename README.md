🌐 [English](#english) | [العربية](#arabic)

---

<a name="english"></a>

# 🚀 Flutter Structure Creator

A command-line tool built with **Dart** that automates the creation of a clean, scalable Flutter project structure — saving you time and keeping your codebase consistent across all projects.

> ✅ **This tool is designed specifically for [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) pattern** — separating your project into `data`, `logic`, and `ui` layers for maximum scalability, testability, and maintainability.

---

## ✨ Features

### 1. Create a New Flutter Project

- Runs `flutter create` automatically
- Generates a full **Clean Architecture** folder structure inside `lib/`
- Creates a ready-to-use `main.dart` with BLoC observer and dependency injection setup
- Generates the app root widget with `MaterialApp` and routing configured
- Optionally creates `assets/` folders (fonts, icons, images, jsons, translations) and registers them in `pubspec.yaml`
- Optionally sets up a full **Dio** HTTP client layer including:
  - `ApiConsumer` abstract class
  - `DioConsumer` implementation
  - `ExceptionsHandler` with all HTTP status codes
  - `ExceptionModel` for structured error handling
- Auto-installs packages: `flutter_bloc`, `get_it`, and optionally `dio`
- Smart class naming — avoids duplicating `App` suffix (e.g. `movie_app` → `MovieApp`, not `MovieAppApp`)

### 2. Add a New Feature

- Adds a complete feature folder structure under `lib/features/`
- Auto-generates `{feature}_screen.dart` and `{feature}_repo.dart`
- Automatically updates `routing_names.dart` with the new route
- Automatically updates `app_router.dart` with the new import and switch case
- Stays running after each feature — no need to restart
- Accepts `home_screen` or `home` as input — strips `_screen` suffix automatically

---

## 📁 Generated Project Structure

### Option 1 — New Flutter Project

```
lib/
├── main.dart
├── {project_name}_app.dart
├── core/
│   ├── routing/
│   │   ├── app_router.dart
│   │   └── routing_names.dart
│   ├── dependency_injection/
│   │   └── dependency_injection.dart
│   ├── network/
│   │   ├── response_result.dart
│   │   ├── api_consumer.dart        ← (if Dio enabled)
│   │   └── dio_consumer.dart        ← (if Dio enabled)
│   ├── exceptions/                  ← (if Dio enabled)
│   │   ├── exception_model.dart
│   │   └── exceptions_handler.dart
│   ├── theming/
│   │   ├── theming_colors.dart
│   │   └── theming_font_styles.dart
│   ├── utils/
│   │   ├── constants/
│   │   │   ├── constant_icons.dart
│   │   │   ├── constant_images.dart
│   │   │   ├── constant_strings.dart
│   │   │   └── constant_validators.dart
│   │   └── observers/
│   │       └── states_observer.dart
│   └── shared/
│       ├── widgets/
│       └── models/
└── features/
    └── home/
        ├── ui/
        │   ├── home_screen.dart
        │   └── widgets/
        ├── data/
        │   ├── home_repo.dart
        │   └── models/
        └── logic/

assets/                              ← (if assets enabled)
├── fonts/
├── icons/
├── images/
├── jsons/
└── translations/
```

### Option 2 — Add a New Feature (e.g. `profile`)

**Folders created:**

```
lib/features/profile/
├── ui/
│   ├── profile_screen.dart          ← auto-generated
│   └── widgets/
├── data/
│   ├── profile_repo.dart            ← auto-generated
│   └── models/
└── logic/
```

**Files updated automatically:**

`routing_names.dart` — new route added:

```dart
enum RoutingNames {
  home("/"),
  profile("/profile");   // ← added

  const RoutingNames(String route);
}
```

`app_router.dart` — new import and case added:

```dart
import 'package:my_app/features/profile/ui/profile_screen.dart'; // ← added

case RoutingNames.profile.route:
  return MaterialPageRoute(builder: (_) => ProfileScreen()); // ← added
```

---

## ⚙️ Requirements

- [Dart SDK](https://dart.dev/get-dart) installed and added to PATH
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed and added to PATH

---

## 🛠️ How to Use

### Step 1 — Clone the repository

```bash
git clone https://github.com/MahmoudRaafatCod/flutter-structure-creator.git
cd flutter-structure-creator
```

### Step 2 — Run the tool

Double-click `run.bat` or run it from the terminal:

```bash
run.bat
```

### Step 3 — Choose an option

```
================================
  Flutter Structure Creator
================================

What would you like to do?
  1. Create a new Flutter project
  2. Add a new feature folder

Enter your choice (1 or 2):
```

---

## 📋 Option 1 — Create a New Flutter Project

You will be asked:

| Question                                                          | Example Input |
| ----------------------------------------------------------------- | ------------- |
| 📁 Enter the path to the folder where the project will be created | `D:\projects` |
| ✏️ Enter the project name                                         | `movie_app`   |
| 📦 Are there any external files? (y/n)                            | `y`           |
| 🌐 Is there an API DIO? (y/n)                                     | `y`           |

The tool will then:

1. Run `flutter create movie_app` inside the specified folder
2. Generate the full folder structure
3. Create all boilerplate files
4. Update `pubspec.yaml` with assets (if enabled)
5. Install `flutter_bloc`, `get_it`, and `dio` (if enabled) automatically

---

## 📋 Option 2 — Add a New Feature

You will be asked once for the project path, then you can keep adding features without restarting:

| Question              | Example Input                 |
| --------------------- | ----------------------------- |
| 📁 Enter project path | `D:\projects\movie_app`       |
| ✏️ Enter feature name | `profile` or `profile_screen` |

The tool will:

1. Create the feature folder structure under `lib/features/profile/`
2. Generate `profile_screen.dart` and `profile_repo.dart`
3. Add `profile` to `routing_names.dart`
4. Add the import and route case to `app_router.dart`
5. Ask for the next feature name — keeps running until you close the terminal

---

## 📦 Auto-installed Packages

| Package        | Condition                     |
| -------------- | ----------------------------- |
| `flutter_bloc` | Always                        |
| `get_it`       | Always                        |
| `dio`          | Only if Dio option is enabled |

---

## 🗂️ Files Overview

| File                             | Description                               |
| -------------------------------- | ----------------------------------------- |
| `flutter_structure_creator.dart` | Creates a full new Flutter project        |
| `create_feature.dart`            | Adds a new feature to an existing project |
| `run.bat`                        | Launcher menu for Windows                 |

---

---

<a name="arabic"></a>

<div dir="rtl">

🌐 [English](#english) | [العربية](#arabic)

---

# 🚀 Flutter Structure Creator — أداة إنشاء هيكل Flutter

أداة سطر أوامر مبنية بلغة **Dart** تقوم بأتمتة إنشاء هيكل مشروع Flutter نظيف وقابل للتوسع — توفر وقتك وتحافظ على اتساق الكود في جميع مشاريعك.

> ✅ **هذه الأداة مصممة خصيصاً لنمط [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)** — تقوم بتقسيم مشروعك إلى طبقات `data` و `logic` و `ui` لضمان أعلى مستوى من قابلية التوسع والاختبار وسهولة الصيانة.

---

## ✨ المميزات

### 1. إنشاء مشروع Flutter جديد

- تشغيل `flutter create` تلقائياً
- توليد هيكل مجلدات **Clean Architecture** كامل داخل `lib/`
- إنشاء ملف `main.dart` جاهز للاستخدام مع BLoC observer وإعداد Dependency Injection
- توليد الـ Widget الرئيسي للتطبيق مع `MaterialApp` والـ Routing
- إنشاء مجلدات `assets/` اختيارياً (fonts, icons, images, jsons, translations) وتسجيلها في `pubspec.yaml`
- إعداد طبقة **Dio** HTTP كاملة اختيارياً تشمل:
  - كلاس `ApiConsumer` المجرد
  - تنفيذ `DioConsumer`
  - `ExceptionsHandler` مع جميع أكواد HTTP
  - `ExceptionModel` للتعامل المنظم مع الأخطاء
- تثبيت الحزم تلقائياً: `flutter_bloc` و `get_it` وإضافة `dio` اختيارياً
- تسمية ذكية للكلاسات — تتجنب تكرار لاحقة `App` (مثال: `movie_app` ← `MovieApp` وليس `MovieAppApp`)

### 2. إضافة Feature جديدة

- إنشاء هيكل مجلدات Feature كامل داخل `lib/features/`
- توليد `{feature}_screen.dart` و `{feature}_repo.dart` تلقائياً
- تحديث `routing_names.dart` بالمسار الجديد تلقائياً
- تحديث `app_router.dart` بالـ import وحالة الـ switch تلقائياً
- يبقى يعمل بعد كل Feature — لا حاجة لإعادة التشغيل
- يقبل `home_screen` أو `home` كمدخل — يحذف لاحقة `_screen` تلقائياً

---

## 📁 هيكل المشروع الناتج

### الخيار 1 — مشروع Flutter جديد

```
lib/
├── main.dart
├── {project_name}_app.dart
├── core/
│   ├── routing/
│   │   ├── app_router.dart
│   │   └── routing_names.dart
│   ├── dependency_injection/
│   │   └── dependency_injection.dart
│   ├── network/
│   │   ├── response_result.dart
│   │   ├── api_consumer.dart        ← (إذا تم تفعيل Dio)
│   │   └── dio_consumer.dart        ← (إذا تم تفعيل Dio)
│   ├── exceptions/                  ← (إذا تم تفعيل Dio)
│   │   ├── exception_model.dart
│   │   └── exceptions_handler.dart
│   ├── theming/
│   │   ├── theming_colors.dart
│   │   └── theming_font_styles.dart
│   ├── utils/
│   │   ├── constants/
│   │   │   ├── constant_icons.dart
│   │   │   ├── constant_images.dart
│   │   │   ├── constant_strings.dart
│   │   │   └── constant_validators.dart
│   │   └── observers/
│   │       └── states_observer.dart
│   └── shared/
│       ├── widgets/
│       └── models/
└── features/
    └── home/
        ├── ui/
        │   ├── home_screen.dart
        │   └── widgets/
        ├── data/
        │   ├── home_repo.dart
        │   └── models/
        └── logic/

assets/                              ← (إذا تم تفعيل الملفات الخارجية)
├── fonts/
├── icons/
├── images/
├── jsons/
└── translations/
```

### الخيار 2 — إضافة Feature جديدة (مثال: `profile`)

**المجلدات التي يتم إنشاؤها:**

```
lib/features/profile/
├── ui/
│   ├── profile_screen.dart          ← يتم إنشاؤه تلقائياً
│   └── widgets/
├── data/
│   ├── profile_repo.dart            ← يتم إنشاؤه تلقائياً
│   └── models/
└── logic/
```

**الملفات التي يتم تحديثها تلقائياً:**

`routing_names.dart` — إضافة المسار الجديد:

```dart
enum RoutingNames {
  home("/"),
  profile("/profile");   // ← تمت الإضافة

  const RoutingNames(String route);
}
```

`app_router.dart` — إضافة الـ import والـ case:

```dart
import 'package:my_app/features/profile/ui/profile_screen.dart'; // ← تمت الإضافة

case RoutingNames.profile.route:
  return MaterialPageRoute(builder: (_) => ProfileScreen()); // ← تمت الإضافة
```

---

## ⚙️ المتطلبات

- [Dart SDK](https://dart.dev/get-dart) مثبت ومضاف إلى PATH
- [Flutter SDK](https://flutter.dev/docs/get-started/install) مثبت ومضاف إلى PATH

---

## 🛠️ طريقة الاستخدام

### الخطوة 1 — استنساخ المستودع

```bash
git clone https://github.com/MahmoudRaafatCod/flutter_structure_creator.git
cd flutter-structure-creator
```

### الخطوة 2 — تشغيل الأداة

انقر نقراً مزدوجاً على `run.bat` أو شغّله من الـ Terminal:

```bash
run.bat
```

### الخطوة 3 — اختر الخيار المطلوب

```
================================
  Flutter Structure Creator
================================

What would you like to do?
  1. Create a new Flutter project
  2. Add a new feature folder

Enter your choice (1 or 2):
```

---

## 📋 الخيار 1 — إنشاء مشروع Flutter جديد

ستُسأل عن:

| السؤال                                     | مثال على الإدخال |
| ------------------------------------------ | ---------------- |
| 📁 مسار المجلد الذي سيتم إنشاء المشروع فيه | `D:\projects`    |
| ✏️ اسم المشروع                             | `movie_app`      |
| 📦 هل هناك ملفات خارجية؟ (y/n)             | `y`              |
| 🌐 هل هناك API DIO؟ (y/n)                  | `y`              |

ستقوم الأداة بعدها بـ:

1. تشغيل `flutter create movie_app` داخل المجلد المحدد
2. توليد هيكل المجلدات الكامل
3. إنشاء جميع الملفات الجاهزة
4. تحديث `pubspec.yaml` بالـ assets (إذا تم التفعيل)
5. تثبيت `flutter_bloc` و `get_it` و `dio` (إذا تم التفعيل) تلقائياً

---

## 📋 الخيار 2 — إضافة Feature جديدة

ستُسأل عن المسار مرة واحدة فقط، ثم تستمر في إضافة Features دون إعادة تشغيل:

| السؤال             | مثال على الإدخال              |
| ------------------ | ----------------------------- |
| 📁 مسار المشروع    | `D:\projects\movie_app`       |
| ✏️ اسم الـ Feature | `profile` أو `profile_screen` |

ستقوم الأداة بـ:

1. إنشاء هيكل المجلدات تحت `lib/features/profile/`
2. توليد `profile_screen.dart` و `profile_repo.dart`
3. إضافة `profile` إلى `routing_names.dart`
4. إضافة الـ import وحالة الـ route إلى `app_router.dart`
5. السؤال عن الـ Feature التالية — تبقى تعمل حتى تغلق الـ Terminal

---

## 📦 الحزم المثبتة تلقائياً

| الحزمة         | الشرط                     |
| -------------- | ------------------------- |
| `flutter_bloc` | دائماً                    |
| `get_it`       | دائماً                    |
| `dio`          | فقط إذا تم تفعيل خيار Dio |

---

## 🗂️ نظرة عامة على الملفات

| الملف                            | الوصف                           |
| -------------------------------- | ------------------------------- |
| `flutter_structure_creator.dart` | ينشئ مشروع Flutter جديد كامل    |
| `create_feature.dart`            | يضيف Feature جديدة لمشروع موجود |
| `run.bat`                        | قائمة التشغيل على Windows       |

</div>
