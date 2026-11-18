import 'package:colegia_atenea/main.dart';
import 'package:colegia_atenea/views/screens/jornada_screen.dart';
import 'package:get/get.dart';

/// Si hay un aviso de jornada pendiente (viene de una notificación de
/// recordatorio de fichaje), lo consume y abre "Mi jornada de hoy".
/// Devuelve true si ha abierto la pantalla.
bool abrirJornadaSiPendiente() {
  if (pendingDeepLink.value != 'jornada') return false;
  pendingDeepLink.value = '';
  Get.to(() => const JornadaScreen());
  return true;
}