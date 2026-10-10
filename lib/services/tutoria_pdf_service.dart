import 'dart:io';

import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

/// Descarga el PDF del acta con la sesión del usuario, lo guarda en la carpeta
/// temporal privada de la app y lo abre. No hay ninguna URL pública.
Future<void> descargarYAbrirActaPdf(BuildContext context, int tutoriaId) async {
  final token = AppSharedPreferences.getBasicAthToken() ?? '';
  final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

  final response = await ApiClass().getTutoriaActaPdf(
    token: token,
    cookie: cookie,
    tutoriaId: tutoriaId.toString(),
  );

  if (!context.mounted) return;

  if (response['status'] != true) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['Message'] ?? 'No se pudo descargar el PDF')),
    );
    return;
  }

  try {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/Acta_Tutoria_$tutoriaId.pdf');
    await file.writeAsBytes(response['bytes'] as List<int>);
    final result = await OpenFile.open(file.path);
    if (result.type != ResultType.done && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  } catch (exception) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el PDF')),
      );
    }
  }
}