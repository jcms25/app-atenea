import 'package:colegia_atenea/models/autorizacion_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:flutter_html/flutter_html.dart';

class AutorizacionDetailScreen extends StatefulWidget {
  final AutorizacionModel autorizacion;

  const AutorizacionDetailScreen({super.key, required this.autorizacion});

  @override
  State<AutorizacionDetailScreen> createState() =>
      _AutorizacionDetailScreenState();
}

class _AutorizacionDetailScreenState extends State<AutorizacionDetailScreen> {
  final TextEditingController _firmaController = TextEditingController();
  bool _isSigning = false;
  bool _signed = false;
  String? _hashVerificacion;
  String? _fechaRespuesta;
  String? _respuestaFirmada;

  @override
  void initState() {
    super.initState();
    final userdata = AppSharedPreferences.getUserData();
    final nombre = '${userdata?.pFname ?? ''} ${userdata?.pLname ?? ''}'.trim();
    if (nombre.isNotEmpty) {
      _firmaController.text = nombre;
    }
  }

  @override
  void dispose() {
    _firmaController.dispose();
    super.dispose();
  }

  Future<void> _firmar(String respuesta) async {
    final firmaNombre = _firmaController.text.trim();
    if (firmaNombre.isEmpty) {
      AppConstants.showCustomToast(
          status: false, message: 'Escribe tu nombre completo para firmar');
      return;
    }

    setState(() => _isSigning = true);

    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final parentId = userdata?.parentWpUsrId ?? '';

      final response = await ApiClass().firmarAutorizacion(
        token: token,
        cookie: cookie,
        parentWpUsrId: parentId,
        respId: widget.autorizacion.respId.toString(),
        respuesta: respuesta,
        firmaNombre: firmaNombre,
      );

      if (response['status'] == true) {
        setState(() {
          _signed = true;
          _isSigning = false;
          _hashVerificacion = response['hash_verificacion'] ?? '';
          _fechaRespuesta = response['fecha_respuesta'] ?? '';
          _respuestaFirmada = respuesta;
        });
        AppConstants.showCustomToast(
            status: true, message: 'Autorización firmada correctamente');
      } else {
        setState(() => _isSigning = false);
        AppConstants.showCustomToast(
            status: false,
            message: response['Message'] ?? 'Error al firmar');
      }
    } catch (e) {
      setState(() => _isSigning = false);
      AppConstants.showCustomToast(status: false, message: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => Navigator.pop(context, _signed),
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alumno
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                  const SizedBox(height: 16),

                  // Contenido HTML
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15)),
                    ),
                    child: Html(
                      data: widget.autorizacion.contenido
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
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_signed) ...[
                    _buildFirmadoConfirmacion(),
                  ] else ...[
                    _buildFormularioFirma(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormularioFirma() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Firma electrónica',
          style: AppTextStyle.getOutfit600(
              textSize: 16, textColor: AppColors.secondary),
        ),
        const SizedBox(height: 8),
        Text(
          'Escribe tu nombre completo para firmar esta autorización.',
          style: AppTextStyle.getOutfit400(
              textSize: 13,
              textColor: AppColors.secondary.withValues(alpha: 0.7)),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _firmaController,
          decoration: InputDecoration(
            hintText: 'Nombre completo',
            hintStyle: AppTextStyle.getOutfit400(
                textSize: 14,
                textColor: AppColors.secondary.withValues(alpha: 0.4)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          style: AppTextStyle.getOutfit400(
              textSize: 15, textColor: AppColors.secondary),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 20),
        if (_isSigning)
          const Center(child: LoadingLayout())
        else
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _mostrarConfirmacion('no_autorizado'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.red.withValues(alpha: 0.4)),
                    ),
                    child: Center(
                      child: Text(
                        'No autorizo',
                        style: AppTextStyle.getOutfit600(
                            textSize: 15, textColor: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _mostrarConfirmacion('autorizado'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Autorizo',
                        style: AppTextStyle.getOutfit600(
                            textSize: 15, textColor: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildFirmadoConfirmacion() {
    final bool autorizado = _respuestaFirmada == 'autorizado';
    final Color color = autorizado ? Colors.green : Colors.red;
    final String texto =
        autorizado ? '✓ Has autorizado' : '✗ No has autorizado';

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(
                autorizado ? Icons.check_circle : Icons.cancel,
                color: color,
                size: 48,
              ),
              const SizedBox(height: 10),
              Text(
                texto,
                style: AppTextStyle.getOutfit600(
                    textSize: 18, textColor: color),
              ),
              const SizedBox(height: 8),
              Text(
                'Firmado: ${_firmaController.text}',
                style: AppTextStyle.getOutfit400(
                    textSize: 13,
                    textColor: AppColors.secondary.withValues(alpha: 0.7)),
              ),
              if (_fechaRespuesta != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Fecha: ${_formatDate(_fechaRespuesta!)}',
                  style: AppTextStyle.getOutfit400(
                      textSize: 12,
                      textColor: AppColors.secondary.withValues(alpha: 0.5)),
                ),
              ],
              if (_hashVerificacion != null &&
                  _hashVerificacion!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Hash: ${_hashVerificacion!.substring(0, 16)}...',
                  style: AppTextStyle.getOutfit400(
                      textSize: 11,
                      textColor: AppColors.secondary.withValues(alpha: 0.4)),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => Navigator.pop(context, true),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Volver',
                style: AppTextStyle.getOutfit600(
                    textSize: 15, textColor: AppColors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  void _mostrarConfirmacion(String respuesta) {
    final bool autorizado = respuesta == 'autorizado';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          autorizado ? '¿Confirmar autorización?' : '¿Confirmar denegación?',
          style: AppTextStyle.getOutfit600(
              textSize: 17, textColor: AppColors.secondary),
        ),
        content: Text(
          autorizado
              ? 'Vas a firmar electrónicamente esta autorización. Esta acción no se puede deshacer.'
              : 'Vas a denegar esta autorización. Esta acción no se puede deshacer.',
          style: AppTextStyle.getOutfit400(
              textSize: 14, textColor: AppColors.secondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style: AppTextStyle.getOutfit400(
                    textSize: 14, textColor: AppColors.secondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _firmar(respuesta);
            },
            child: Text(
              autorizado ? 'Autorizo' : 'No autorizo',
              style: AppTextStyle.getOutfit600(
                  textSize: 14,
                  textColor: autorizado ? AppColors.primary : Colors.red),
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