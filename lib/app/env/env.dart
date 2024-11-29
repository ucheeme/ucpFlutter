import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'BASEURL_STAGING')
  static const String baseUrlStaging = _Env.baseUrlStaging;

}
