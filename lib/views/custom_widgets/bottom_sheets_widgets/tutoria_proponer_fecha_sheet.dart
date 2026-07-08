import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Bottom sheet para proponer una nueva fecha/hora de tutoría.
/// Devuelve un Map con 'fecha_propuesta' (Y-m-d H:i:s) y 'mensaje',
/// o null si se cancela.
Future<Map<String, String>?> showTutoriaProponerFechaSheet(
  BuildContext context, {
  String title = 'Proponer nueva fecha',
  DateTime? fechaInicial,
}) {
  return showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _TutoriaProponerFechaContent(
      title: title,
      fechaInicial: fechaInicial,
    ),
  );
}

class _TutoriaProponerFechaContent extends StatefulWidget {
  final String title;
  final DateTime? fechaInicial;

  const _TutoriaProponerFechaContent({required this.title, this.fechaInicial});

  @override
  State<_TutoriaProponerFechaContent> createState() => _TutoriaProponerFechaContentState();
}

class _TutoriaProponerFechaContentState extends State<_TutoriaProponerFechaContent> {
  late DateTime _fecha;
  late TimeOfDay _hora;
  final TextEditingController _mensajeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final base = widget.fechaInicial ?? DateTime.now().add(const Duration(days: 1));
    _fecha = DateTime(base.year, base.month, base.day);
    _hora = TimeOfDay(hour: base.hour == 0 ? 9 : base.hour, minute: base.minute);
  }

  @override
  void dispose() {
    _mensajeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('es', 'ES'),
      initialDate: _fecha,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _fecha = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _hora,
      builder: (context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: const Locale('es', 'ES'),
          child: child,
        );
      },
    );
    if (picked != null) setState(() => _hora = picked);
  }

  void _confirmar() {
    final fechaCompleta = DateTime(_fecha.year, _fecha.month, _fecha.day, _hora.hour, _hora.minute);
    final formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(fechaCompleta);
    Navigator.pop(context, {
      'fecha_propuesta': formatted,
      'mensaje': _mensajeController.text.trim(),
    });
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
          Text(widget.title,
              style: AppTextStyle.getOutfit600(textSize: 18, textColor: AppColors.secondary)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(DateFormat('dd/MM/yyyy').format(_fecha)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.access_time, size: 16),
                  label: Text(_hora.format(context)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _mensajeController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Mensaje (opcional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _confirmar,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Confirmar'),
            ),
          ),
        ],
      ),
    );
  }
}