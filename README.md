# Employee Manager – Flutter + GetX + REST + Repository + JWT

## Run it
```bash
flutter create employee_app --platforms=android,ios
# copy this project's `lib/` folder and `pubspec.yaml` over the generated ones
cd employee_app
flutter pub get
flutter run
```
Demo login (dummyjson.com): **emilys / emilyspass**

### Platform notes
* **Android** – `android/app/build.gradle`: set `minSdkVersion 23` (flutter_secure_storage).
  Add `<uses-permission android:name="android.permission.INTERNET"/>` to
  `android/app/src/main/AndroidManifest.xml` for release builds.
* **iOS** – no extra setup.

## Architecture
```
lib/
├─ main.dart                      start route chosen from stored JWT
├─ app/
│  ├─ bindings/initial_binding    singletons: storage, ApiClient, repositories
│  └─ routes/app_pages            GetX routes
├─ core/
│  ├─ network/                    Dio client (Bearer interceptor, 401 → logout, error mapping)
│  ├─ storage/token_storage       JWT in secure storage
│  ├─ utils/                      validators, snackbars
│  ├─ widgets/ theme/ models/
├─ data/
│  ├─ models/                     AuthUser, Product, Employee
│  └─ repositories/               abstract interface + implementation per resource
└─ modules/                       controller / view / binding per feature
   ├─ auth  ├─ home  ├─ products  └─ employees (list + add/edit form)
```
Views → Controllers (GetX, Rx state) → Repositories (interfaces) → ApiClient (Dio).

## Using your own backend
Edit `lib/core/constants/api_constants.dart` (base URL + paths), adjust the
`fromJson`/`toJson` in `data/models/`, and set `simulatedBackend = false`.
