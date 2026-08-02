import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';

class VersionCheckService {
  static const String _endpoint =
      'https://colegioatenea.es/wp-json/scl-api/v1/version-check';

  static const String _endpointAviso =
      'https://colegioatenea.es/wp-json/scl-api/v1/aviso-activo';

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
  static Future<void> _openStore(String url) async {
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

      // Seleccionar bloque según plataforma
      final Map<String, dynamic> plataforma =
          Platform.isAndroid ? data['android'] : data['ios'];

      final info = await PackageInfo.fromPlatform();
      final instalada = info.version;
      final minima = plataforma['version_minima'] ?? '0.0.0';
      final recomendada = plataforma['version_recomendada'] ?? '0.0.0';
      final url = plataforma['url'] ?? '';

      if (!context.mounted) return;

      if (_compareVersions(instalada, minima) < 0) {
        // Actualización OBLIGATORIA — diálogo no descartable
        final versionObligatoria = plataforma['version_actual'] ?? minima;
        _showDialog(
          context: context,
          titulo: 'Actualización obligatoria',
          mensaje:
              'Tienes la versión $instalada y es necesario actualizar a la versión $versionObligatoria para continuar.',
          obligatorio: true,
          url: url,
        );
      } else if (_compareVersions(instalada, recomendada) < 0) {
        // Actualización RECOMENDADA — diálogo descartable
        final versionNueva = plataforma['version_actual'] ?? recomendada;
        _showDialog(
          context: context,
          titulo: 'Nueva versión disponible',
          mensaje:
              'Tienes la versión $instalada y hay una nueva versión $versionNueva disponible con mejoras y correcciones.',
          obligatorio: false,
          url: url,
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
    required String url,
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
              onPressed: () => _openStore(url),
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  /// Comprueba si hay avisos emergentes activos y los muestra en cadena.
  /// Llamar desde initState de MainScreen, después de check().
  static Future<void> checkAviso(BuildContext context) async {
    try {
      final role = AppSharedPreferences.getUserLoggedInRole() ?? '';

      final uri = Uri.parse(_endpointAviso).replace(queryParameters: {
        'role': role,
      });

      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) return;

      final data = json.decode(response.body);
      if (data['status'] != true) return;

      final avisos = data['avisos'] as List<dynamic>? ?? [];
      if (avisos.isEmpty) return;

      final descartados = AppSharedPreferences.sharedPreferences
              ?.getStringList('avisos_descartados') ??
          [];

      final pendientes = avisos.where((a) {
        final id = (a['aviso_id'] as String? ?? '');
        return id.isNotEmpty && !descartados.contains(id);
      }).toList();

      if (pendientes.isEmpty) return;
      if (!context.mounted) return;

      _mostrarAvisosEnCadena(context, pendientes, descartados, 0);
    } catch (_) {
      // Si falla la llamada se ignora silenciosamente.
    }
  }

  static void _mostrarAvisosEnCadena(
    BuildContext context,
    List<dynamic> avisos,
    List<String> descartados,
    int indice,
  ) {
    if (indice >= avisos.length) return;
    if (!context.mounted) return;

    final aviso           = avisos[indice] as Map<String, dynamic>;
    final titulo          = aviso['titulo']           as String? ?? '';
    final mensaje         = aviso['mensaje']          as String? ?? '';
    final imagenBanner    = aviso['imagen_banner']    as String? ?? '';
    final imagenContenido = aviso['imagen_contenido'] as String? ?? '';
    final colorFondo      = _parseColor(aviso['color_fondo']   as String? ?? '#ffffff');
    final colorTitulo     = _parseColor(aviso['color_titulo']  as String? ?? '#000000');
    final colorMensaje    = _parseColor(aviso['color_mensaje'] as String? ?? '#333333');
    final avisoId         = aviso['aviso_id']         as String? ?? '';
    final mostrarFecha    = aviso['mostrar_fecha']    as bool?   ?? false;
    final fechaFin        = aviso['fecha_fin']        as String? ?? '';

    if (mensaje.isEmpty) {
      _mostrarAvisosEnCadena(context, avisos, descartados, indice + 1);
      return;
    }

    bool noVolverMostrar = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: colorFondo,
          title: null,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imagenBanner.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imagenBanner,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                if (imagenBanner.isNotEmpty) const SizedBox(height: 12),
                if (titulo.isNotEmpty) ...[
                  Text(titulo, style: TextStyle(color: colorTitulo, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                ],
                if (imagenContenido.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imagenContenido,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                if (imagenContenido.isNotEmpty) const SizedBox(height: 12),
                Text(mensaje, style: TextStyle(color: colorMensaje)),
                if (mostrarFecha && fechaFin.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Válido hasta: $fechaFin',
                    style: TextStyle(
                      fontSize: 11,
                      color: colorMensaje.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: noVolverMostrar,
                        onChanged: (val) =>
                            setState(() => noVolverMostrar = val ?? false),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(color: colorMensaje),
                        checkColor: colorFondo,
                        fillColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? colorMensaje
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'No volver a mostrar',
                      style: TextStyle(fontSize: 12, color: colorMensaje),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (noVolverMostrar && avisoId.isNotEmpty) {
                      final lista = AppSharedPreferences.sharedPreferences
                              ?.getStringList('avisos_descartados') ??
                          [];
                      lista.add(avisoId);
                      await AppSharedPreferences.sharedPreferences
                          ?.setStringList('avisos_descartados', lista);
                    }
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  },
                  child: const Text('Entendido'),
                ),
              ],
            ),
          ],
        ),
      ),
    ).then((_) {
      if (context.mounted) {
        _mostrarAvisosEnCadena(context, avisos, descartados, indice + 1);
      }
    });
  }

  static Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return const Color(0xFFFFFFFF);
    }
  }
}