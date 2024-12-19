# ucpFlutter
 CWG cooperative app
 To build app apk for various variant 
 stagging -- flutter build apk -t \lib/app/main/main_stagging.dart

production -- flutter build apk -t\lib/app/main/main_production.dart

To build appBundle
production --  flutter build appbundle -t \lib/flavour/main_production.dart
To build environment
1. delete env.g file in env file
2. run flutter clean
3. run flutter pub get
4. run dart run build_runner build --delete-conflicting-outputs

