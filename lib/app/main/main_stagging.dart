import '../env/env.dart';
import '../flavour/flavour.dart';
import 'main.dart';

Future<void> main() async {
  final devConfig = AppFlavorConfig(
    name: 'Development',
    apiBaseUrl: Env.baseUrlStaging,
  );
  mainCommon(devConfig);
}