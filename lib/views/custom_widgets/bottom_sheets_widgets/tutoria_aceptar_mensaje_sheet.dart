import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';

/// Bottom sheet para aceptar una tutoría con un mensaje opcional
/// (por ejemplo: "Nos vemos el próximo martes"). Si se deja vacío,
/// se usará el mensaje genérico de notificación.
/// Devuelve el texto (puede ser vacío) si se confirma, o null si se cancela.
Future<String?> showTutoriaAceptarMensajeSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _TutoriaAceptarMensajeContent(),
  );
}

class _TutoriaAceptarMensajeContent extends StatefulWidget {
  const _TutoriaAceptarMensajeContent();

  @override
  State<_TutoriaAceptarMensajeContent> createState() => _TutoriaAceptarMensajeContentState();
}

class _TutoriaAceptarMensajeContentState extends State<_TutoriaAceptarMensajeContent> {
  final TextEditingController _mensajeController = TextEditingController();

  @override
  void dispose() {
    _mensajeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aceptar tutoría',
              style: AppTextStyle.getOutfit600(textSize: 18, textColor: AppColors.secondary)),
          const SizedBox(height: 8),
          Text(
            'Puede añadir un mensaje opcional (por ejemplo: "Nos vemos el próximo martes"). '
            'Si lo deja en blanco, se enviará un aviso genérico de confirmación.',
            style: AppTextStyle.getOutfit400(
                textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _mensajeController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Mensaje (opcional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _mensajeController.text.trim()),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Confirmar aceptación'),
            ),
          ),
        ],
      ),
    );
  }
}