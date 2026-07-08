import 'package:colegia_atenea/models/tutoria_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';

class TutoriaHistorialWidget extends StatefulWidget {
  final int tutoriaId;
  final String currentUserRol; // 'padre' o 'profesor'

  const TutoriaHistorialWidget({
    super.key,
    required this.tutoriaId,
    required this.currentUserRol,
  });

  @override
  State<TutoriaHistorialWidget> createState() => _TutoriaHistorialWidgetState();
}

class _TutoriaHistorialWidgetState extends State<TutoriaHistorialWidget> {
  bool _expanded = false;
  bool _loading = false;
  bool _loaded = false;
  List<TutoriaDetalleModel> _detalles = [];

  Future<void> _toggle() async {
    setState(() => _expanded = !_expanded);
    if (_expanded && !_loaded) {
      setState(() => _loading = true);
      try {
        final token = AppSharedPreferences.getBasicAthToken() ?? '';
        final userdata = AppSharedPreferences.getUserData();
        final cookie = userdata?.cookies ?? '';

        final response = await ApiClass().getTutoriasHistorial(
          token: token,
          cookie: cookie,
          tutoriaId: widget.tutoriaId.toString(),
        );

        if (response['status'] == true) {
          final List data = response['historial'] ?? [];
          setState(() {
            _detalles = _filtrarNotas(TutoriaDetalleModel.listFromJson(data));
            _loaded = true;
            _loading = false;
          });
        } else {
          setState(() => _loading = false);
        }
      } catch (e) {
        setState(() => _loading = false);
      }
    }
  }

  // Regla: mostrar todos los registros excepto notas de acta,
  // de las que solo se muestra la última.
  List<TutoriaDetalleModel> _filtrarNotas(List<TutoriaDetalleModel> lista) {
    final notas = lista.where((d) => d.tipo == 'nota').toList();
    if (notas.length <= 1) return lista;
    final ultimaNota = notas.last;
    return lista.where((d) => d.tipo != 'nota' || d.id == ultimaNota.id).toList();
  }

  String _tipoLabel(String tipo) {
    switch (tipo) {
      case 'propuesta':
        return 'Propuesta de fecha';
      case 'aceptacion':
        return 'Aceptación';
      case 'aplazamiento':
        return 'Aplazamiento';
      case 'rechazo':
        return 'Nueva propuesta';
      case 'cancelacion':
        return 'Cancelación';
      case 'nota':
        return 'Acta de la tutoría';
      default:
        return tipo;
    }
  }

  String _formatFecha(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final parts = dateStr.split(' ');
      final dateParts = parts[0].split('-');
      final hora = parts.length > 1 ? parts[1].substring(0, 5) : '';
      return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}${hora.isNotEmpty ? ' $hora' : ''}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _toggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Ver historial de conversación',
                  style: AppTextStyle.getOutfit600(
                      textSize: 12, textColor: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          _loading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                      child: SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))),
                )
              : _detalles.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Sin movimientos registrados',
                        style: AppTextStyle.getOutfit400(
                            textSize: 12,
                            textColor: AppColors.secondary.withValues(alpha: 0.5)),
                      ),
                    )
                  : Column(
                      children: _detalles.map((d) => _buildMensaje(d)).toList(),
                    ),
      ],
    );
  }

  Widget _buildMensaje(TutoriaDetalleModel d) {
    // Nunca mostrar anotaciones privadas del profesor al padre.
    // (El historial no trae ese campo, pero se deja la comprobación
    // explícita por seguridad si en el futuro se añadiera.)
    final bool esPropio = d.autorRol == widget.currentUserRol;

    return Align(
      alignment: esPropio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: esPropio
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.secondary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_tipoLabel(d.tipo)} · ${d.autorNombre.isNotEmpty ? d.autorNombre : (d.autorRol == 'padre' ? 'Familia' : 'Profesor/a')}',
              style: AppTextStyle.getOutfit600(
                  textSize: 11, textColor: AppColors.secondary.withValues(alpha: 0.7)),
            ),
            if (d.mensaje.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                d.mensaje,
                style: AppTextStyle.getOutfit400(
                    textSize: 13, textColor: AppColors.secondary),
              ),
            ],
            if (d.fechaPropuesta != null && d.fechaPropuesta!.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                'Fecha: ${_formatFecha(d.fechaPropuesta!)}',
                style: AppTextStyle.getOutfit400(
                    textSize: 11, textColor: AppColors.secondary.withValues(alpha: 0.6)),
              ),
            ],
            const SizedBox(height: 3),
            Text(
              _formatFecha(d.fechaCreacion),
              style: AppTextStyle.getOutfit400(
                  textSize: 10, textColor: AppColors.secondary.withValues(alpha: 0.4)),
            ),
          ],
        ),
      ),
    );
  }
}