import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheckService {
  static const String _endpoint =
      'https://colegioatenea.es/wp-json/scl-api/v1/version-check';

  /// Compara dos versiones semánticas (ej. "1.9.2" vs "1.10.0").
  /// Devuelve -1, 0 o 1 (menor, igual, mayor).
  static int _compareVersions(String v1, String v2) {
    final a = v1.split('.').map(int.parse).toList();
    final b = v2.split('.').map(int.parse).toList();
    for (int i = 0; i < 3; i++) {
      final x = i < a.length ? a[i] : 0;
      final y = i < b.length ? b[i] : 0;
      if (x < y) return -1;
      if (x > y) return 1;
    }
    return 0;
  }

  /// Abre la tienda correspondiente (Android o iOS).
  static Future<void> _openStore(String urlAndroid, String urlIos) async {
    final String url = Platform.isAndroid ? urlAndroid : urlIos;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Comprueba la versión y muestra el diálogo si procede.
  /// Llamar desde initState de MainScreen.
  static Future<void> check(BuildContext context) async {
    try {
      final response = await http
          .get(Uri.parse(_endpoint))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) return;

      final data = json.decode(response.body);
      if (data['status'] != true) return;

      final info = await PackageInfo.fromPlatform();
      final instalada = info.version; // ej. "1.9.2"
      final minima = data['version_minima'] ?? '0.0.0';
      final recomendada = data['version_recomendada'] ?? '0.0.0';
      final urlAndroid = data['url_android'] ?? '';
      final urlIos = data['url_ios'] ?? '';

      if (!context.mounted) return;

      if (_compareVersions(instalada, minima) < 0) {
        // Actualización OBLIGATORIA — diálogo no descartable
        _showDialog(
          context: context,
          titulo: 'Actualización obligatoria',
          mensaje: data['mensaje_obligatorio'] ??
              'Por favor, actualiza la app para continuar.',
          obligatorio: true,
          urlAndroid: urlAndroid,
          urlIos: urlIos,
        );
      } else if (_compareVersions(instalada, recomendada) < 0) {
        // Actualización RECOMENDADA — diálogo descartable
        _showDialog(
          context: context,
          titulo: 'Nueva versión disponible',
          mensaje: data['mensaje_recomendado'] ??
              'Hay una nueva versión disponible con mejoras y correcciones.',
          obligatorio: false,
          urlAndroid: urlAndroid,
          urlIos: urlIos,
        );
      }
    } catch (_) {
      // Si falla la llamada (sin red, timeout…) se ignora silenciosamente
      // para no bloquear el acceso a la app.
    }
  }

  static void _showDialog({
    required BuildContext context,
    required String titulo,
    required String mensaje,
    required bool obligatorio,
    required String urlAndroid,
    required String urlIos,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: !obligatorio,
        child: AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            if (!obligatorio)
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Más tarde'),
              ),
            ElevatedButton(
              onPressed: () => _openStore(urlAndroid, urlIos),
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}