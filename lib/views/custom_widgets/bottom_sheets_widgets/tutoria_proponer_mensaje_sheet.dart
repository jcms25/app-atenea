import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';

/// Bottom sheet para que el padre proponga un cambio sobre la fecha/hora
/// solicitada por el profesor, mediante un mensaje obligatorio
/// (sin selector de fecha/hora: el centro fija los horarios de atención).
/// Devuelve el mensaje escrito, o null si se cancela.
Future<String?> showTutoriaProponerMensajeSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _TutoriaProponerMensajeContent(),
  );
}

class _TutoriaProponerMensajeContent extends StatefulWidget {
  const _TutoriaProponerMensajeContent();

  @override
  State<_TutoriaProponerMensajeContent> createState() => _TutoriaProponerMensajeContentState();
}

class _TutoriaProponerMensajeContentState extends State<_TutoriaProponerMensajeContent> {
  final TextEditingController _mensajeController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _mensajeController.dispose();
    super.dispose();
  }

  void _confirmar() {
    final texto = _mensajeController.text.trim();
    if (texto.isEmpty) {
      setState(() => _error = 'Este campo es obligatorio');
      return;
    }
    Navigator.pop(context, texto);
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
          Text('Proponer un cambio',
              style: AppTextStyle.getOutfit600(textSize: 18, textColor: AppColors.secondary)),
          const SizedBox(height: 8),
          Text(            
            'Indique aquí el motivo o la alternativa que propone (por ejemplo: "No puedo a esa hora" o "¿podría ser un poco antes, por favor?")'
            'El profesor intentará ajustar su horario para ofrecerle una fecha y hora que le convengaa a ambos',
            style: AppTextStyle.getOutfit400(
                textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _mensajeController,
            maxLines: 4,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Escriba su propuesta',
              border: const OutlineInputBorder(),
              errorText: _error,
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _confirmar,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Enviar propuesta'),
            ),
          ),
        ],
      ),
    );
  }
}