import 'package:colegia_atenea/models/autorizacion_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AutorizacionHistorialDetailScreen extends StatefulWidget {
  final AutorizacionHistorialModel autorizacion;

  const AutorizacionHistorialDetailScreen({super.key, required this.autorizacion});

  @override
  State<AutorizacionHistorialDetailScreen> createState() =>
      _AutorizacionHistorialDetailScreenState();
}

class _AutorizacionHistorialDetailScreenState
    extends State<AutorizacionHistorialDetailScreen> {
  bool _contenidoExpandido = false;

  @override
  Widget build(BuildContext context) {
    final bool autorizado = widget.autorizacion.respuesta == 'autorizado';
    final Color statusColor = autorizado ? Colors.green : Colors.red;
    final String statusText = autorizado ? 'AUTORIZADO' : 'NO AUTORIZADO';

    return Scaffold(
      body: Column(
        children: [
          // Header
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
                    widget.autorizacion.titulo,
                    style: AppTextStyle.getOutfit600(
                        textSize: 18, textColor: AppColors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Contenido
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
                                  'Autorización firmada electrónicamente',
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 12,
                                      textColor: AppColors.secondary
                                          .withValues(alpha: 0.6)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Curso ${widget.autorizacion.academicYear}',
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
                            widget.autorizacion.alumnoNombre,
                            style: AppTextStyle.getOutfit600(
                                textSize: 14, textColor: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Título expandible
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _contenidoExpandido = !_contenidoExpandido;
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
                              color: AppColors.primary.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Ver documento firmado',
                                style: AppTextStyle.getOutfit600(
                                    textSize: 13,
                                    textColor: AppColors.primary),
                              ),
                            ),
                            Icon(
                              _contenidoExpandido
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Contenido expandible
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: _contenidoExpandido
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                        child: widget.autorizacion.contenidoFirmado.isNotEmpty
                            ? Html(
                                data: widget.autorizacion.contenidoFirmado
                                    .replaceAll('\r\n', '<br>'),
                                style: {
                                  'body': Style(
                                    fontSize: FontSize(14),
                                    fontFamily: 'Outfit',
                                    color: AppColors.secondary,
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                  ),
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'Contenido no disponible para firmas anteriores a esta actualización.',
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 13,
                                      textColor: AppColors.secondary
                                          .withValues(alpha: 0.5)),
                                ),
                              ),
                      ),
                      secondChild: const SizedBox.shrink(),
                    ),
                    const Divider(height: 24, indent: 16, endIndent: 16),
                    // Sello de firma
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: statusColor.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                autorizado
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: statusColor,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                statusText,
                                style: AppTextStyle.getOutfit700(
                                    textSize: 15, textColor: statusColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _infoRow('Firmado por', widget.autorizacion.firmaNombre),
                          _infoRow('Fecha', _formatDate(widget.autorizacion.fechaRespuesta)),
                          if (widget.autorizacion.segundoFirmanteNombre.isNotEmpty)
                            _infoRow('2º firmante', widget.autorizacion.segundoFirmanteNombre),
                          const SizedBox(height: 8),
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
                            widget.autorizacion.hashVerificacion,
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: AppTextStyle.getOutfit600(
                  textSize: 12,
                  textColor: AppColors.secondary.withValues(alpha: 0.6)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.getOutfit400(
                  textSize: 12, textColor: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
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
}