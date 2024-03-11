import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'GOOGLESERVICEACCOUNTKEY')
  static const String googleServiceAccountKey = _Env.googleServiceAccountKey;
}
