import 'package:colegia_atenea/models/servicio_contratado_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';

class SolicitudDetalleScreen extends StatefulWidget {
  final SolicitudHistorialModel solicitud;

  const SolicitudDetalleScreen({super.key, required this.solicitud});

  @override
  State<SolicitudDetalleScreen> createState() => _SolicitudDetalleScreenState();
}

class _SolicitudDetalleScreenState extends State<SolicitudDetalleScreen> {
  bool _condicionesExpandidas = false;

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'activa':
        return Colors.green;
      case 'enviada':
        return Colors.orange;
      default:
        return AppColors.secondary;
    }
  }

  String _labelEstado(String estado) {
    switch (estado) {
      case 'activa':
        return 'ACTIVA';
      case 'enviada':
        return 'ENVIADA';
      default:
        return estado.toUpperCase();
    }
  }

  IconData _iconEstado(String estado) {
    switch (estado) {
      case 'activa':
        return Icons.check_circle;
      case 'enviada':
        return Icons.schedule;
      default:
        return Icons.info_outline;
    }
  }

  String _labelTipo(String? tipo) {
    switch (tipo) {
      case 'mensual':
        return 'Mensual';
      case 'dias_sueltos':
        return 'Días sueltos';
      default:
        return '';
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final parts = dateStr.split(' ');
      final dateParts = parts[0].split('-');
      return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color estadoColor = _colorEstado(widget.solicitud.estado);
    final String estadoLabel = _labelEstado(widget.solicitud.estado);
    final IconData estadoIcon = _iconEstado(widget.solicitud.estado);

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 18),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios,
                      color: AppColors.white, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.solicitud.formularioNombre,
                    style: AppTextStyle.getOutfit600(
                        textSize: 18, textColor: AppColors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Encabezado documento
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(AppImages.logo, height: 60),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Colegio Atenea',
                                  style: AppTextStyle.getOutfit700(
                                      textSize: 16,
                                      textColor: AppColors.primary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Solicitud de servicio',
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 12,
                                      textColor: AppColors.secondary
                                          .withValues(alpha: 0.6)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Curso ${widget.solicitud.academicYear}',
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 12,
                                      textColor: AppColors.secondary
                                          .withValues(alpha: 0.6)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Alumno
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline,
                              color: AppColors.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.solicitud.alumnoNombre} (${widget.solicitud.claseNombre})',
                            style: AppTextStyle.getOutfit600(
                                textSize: 14, textColor: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Datos de la solicitud
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _infoRow('Servicio',
                              widget.solicitud.formularioNombre),
                          if (widget.solicitud.tipoServicio.isNotEmpty)
                            _infoRow('Modalidad',
                                _labelTipo(widget.solicitud.tipoServicio)),
                          _infoRow('Fecha solicitud',
                              _formatDate(widget.solicitud.fechaSolicitud)),
                          _infoRow(
                              'Firmado por', widget.solicitud.firmaNombre),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Condiciones expandibles
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _condicionesExpandidas = !_condicionesExpandidas;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  AppColors.primary.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Ver condiciones del servicio',
                                style: AppTextStyle.getOutfit600(
                                    textSize: 13,
                                    textColor: AppColors.primary),
                              ),
                            ),
                            Icon(
                              _condicionesExpandidas
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: _condicionesExpandidas
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                        child: Text(
                          widget.solicitud.condicionesTexto.isNotEmpty
                              ? widget.solicitud.condicionesTexto
                              : 'No disponible',
                          style: AppTextStyle.getOutfit400(
                              textSize: 13,
                              textColor:
                                  AppColors.secondary.withValues(alpha: 0.7)),
                        ),
                      ),
                      secondChild: const SizedBox.shrink(),
                    ),
                    const Divider(height: 24, indent: 16, endIndent: 16),
                    // Sello de estado
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: estadoColor.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: estadoColor.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(estadoIcon,
                                  color: estadoColor, size: 22),
                              const SizedBox(width: 8),
                              Text(
                                estadoLabel,
                                style: AppTextStyle.getOutfit700(
                                    textSize: 15, textColor: estadoColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(height: 1),
                          const SizedBox(height: 8),
                          Text(
                            'Verificación',
                            style: AppTextStyle.getOutfit600(
                                textSize: 12,
                                textColor: AppColors.secondary
                                    .withValues(alpha: 0.5)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.solicitud.hashVerificacion,
                            style: AppTextStyle.getOutfit400(
                                textSize: 10,
                                textColor: AppColors.secondary
                                    .withValues(alpha: 0.4)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: AppTextStyle.getOutfit600(
                  textSize: 13,
                  textColor: AppColors.secondary.withValues(alpha: 0.6)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.getOutfit400(
                  textSize: 13, textColor: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }
}