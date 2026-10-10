import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  // Indica si el dispositivo puede autenticar al usuario, ya sea con
  // biometría (huella o cara) o con el PIN/patrón del propio móvil.
  static Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  // Lanza la autenticación del sistema. Devuelve true solo si el usuario
  // se autentica correctamente. Si falla, cancela o el sistema lanza una
  // LocalAuthException (sin biometría configurada, bloqueo por intentos...),
  // devuelve false.
  static Future<bool> authenticate({required String reason}) async {
    try {
      return await _auth.authenticate(localizedReason: reason);
    } catch (_) {
      return false;
    }
  }
}
