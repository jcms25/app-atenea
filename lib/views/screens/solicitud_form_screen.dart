import 'package:colegia_atenea/models/servicio_contratado_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SolicitudFormScreen extends StatefulWidget {
  final FormularioSolicitudModel formulario;
  final List<SolicitudHistorialModel> solicitudesExistentes;

  const SolicitudFormScreen({
    super.key,
    required this.formulario,
    this.solicitudesExistentes = const [],
  });

  @override
  State<SolicitudFormScreen> createState() => _SolicitudFormScreenState();
}

class _SolicitudFormScreenState extends State<SolicitudFormScreen> {
  MisHijosSolicitudResponseModel? datosPrecargados;
  bool isLoading = true;
  bool isEnviando = false;

  HijoSolicitudModel? hijoSeleccionado;
  String tipoSeleccionado = 'mensual';

  final TextEditingController _nombrePadreCtrl = TextEditingController();
  final TextEditingController _nifPadreCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _telefonoCtrl = TextEditingController();
  final TextEditingController _ibanCtrl = TextEditingController();
  final TextEditingController _titularCtrl = TextEditingController();
  final TextEditingController _nifTitularCtrl = TextEditingController();
  final TextEditingController _firmaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDatos();
  }

  @override
  void dispose() {
    _nombrePadreCtrl.dispose();
    _nifPadreCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
    _ibanCtrl.dispose();
    _titularCtrl.dispose();
    _nifTitularCtrl.dispose();
    _firmaCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDatos() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final parentId = userdata?.parentWpUsrId ?? '';

      final response = await ApiClass().getSolicitudesMisHijos(
        token: token,
        cookie: cookie,
        parentWpUsrId: parentId,
      );

      if (response['status'] == true) {
        final datos = MisHijosSolicitudResponseModel.fromJson(
            response['data'] ?? {});
        setState(() {
          datosPrecargados = datos;
          _nombrePadreCtrl.text = datos.padre.nombreCompleto;
          _nifPadreCtrl.text = datos.padre.nif;
          _emailCtrl.text = datos.padre.email;
          _telefonoCtrl.text = datos.padre.telefono;
          _ibanCtrl.text = datos.padre.iban;
          _titularCtrl.text = datos.padre.titularCuenta;
          _nifTitularCtrl.text = datos.padre.nifTitular;
          _firmaCtrl.text = datos.padre.nombreCompleto;
          if (datos.hijos.isNotEmpty) {
            hijoSeleccionado = datos.hijos.first;
          }
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _enviarSolicitud() async {
    if (hijoSeleccionado == null) {
      Get.snackbar('Error', 'Selecciona un alumno',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800);
      return;
    }
    if (_firmaCtrl.text.trim().isEmpty) {
      Get.snackbar('Error', 'Introduce tu firma',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800);
      return;
    }
    if (widget.formulario.requiereIban && _ibanCtrl.text.trim().isEmpty) {
      Get.snackbar('Error', 'Introduce el IBAN',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800);
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Confirmar solicitud',
          style: AppTextStyle.getOutfit600(
              textSize: 17, textColor: AppColors.secondary),
        ),
        content: Text(
          'Vas a enviar la solicitud de ${widget.formulario.nombre} para '
          '${hijoSeleccionado!.nombre}. ¿Confirmas?',
          style: AppTextStyle.getOutfit400(
              textSize: 14, textColor: AppColors.secondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar',
                style: AppTextStyle.getOutfit400(
                    textSize: 14, textColor: AppColors.secondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Confirmar',
                style: AppTextStyle.getOutfit600(
                    textSize: 14, textColor: AppColors.primary)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() => isEnviando = true);

    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final parentId = userdata?.parentWpUsrId ?? '';

      final response = await ApiClass().postSolicitudEnviar(
        token: token,
        cookie: cookie,
        body: {
          'parent_wp_usr_id': parentId,
          'formulario_id': widget.formulario.id.toString(),
          'student_id': hijoSeleccionado!.wpUsrId.toString(),
          'tipo_servicio': tipoSeleccionado,
          'nombre_padre': _nombrePadreCtrl.text.trim(),
          'nif_padre': _nifPadreCtrl.text.trim(),
          'email_padre': _emailCtrl.text.trim(),
          'telefono_padre': _telefonoCtrl.text.trim(),
          'iban': _ibanCtrl.text.trim(),
          'titular_cuenta': _titularCtrl.text.trim(),
          'nif_titular': _nifTitularCtrl.text.trim(),
          'firma_nombre': _firmaCtrl.text.trim(),
        },
      );

      setState(() => isEnviando = false);

      if (response['status'] == true) {
        if (!mounted) return;
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Solicitud enviada',
              style: AppTextStyle.getOutfit600(
                  textSize: 17, textColor: AppColors.secondary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tu solicitud de ${widget.formulario.nombre} ha sido enviada correctamente.',
                  style: AppTextStyle.getOutfit400(
                      textSize: 14, textColor: AppColors.secondary),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hash de verificación:',
                  style: AppTextStyle.getOutfit400(
                      textSize: 11,
                      textColor: AppColors.secondary.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 4),
                Text(
                  response['data']?['hash_verificacion'] ?? '',
                  style: AppTextStyle.getOutfit400(
                      textSize: 10,
                      textColor: AppColors.secondary.withValues(alpha: 0.5)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context, true);
                },
                child: Text('Aceptar',
                    style: AppTextStyle.getOutfit600(
                        textSize: 14, textColor: AppColors.primary)),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          response['Message'] ?? 'Error al enviar la solicitud',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
      }
    } catch (e) {
      setState(() => isEnviando = false);
      Get.snackbar('Error', 'Error al enviar la solicitud',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800);
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
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios,
                      color: AppColors.white, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Solicitud — ${widget.formulario.nombre}',
                    style: AppTextStyle.getOutfit600(
                        textSize: 20, textColor: AppColors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: LoadingLayout())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSeccion('Alumno'),
                        _buildSelectorHijo(),
                        const SizedBox(height: 16),
                        if (widget.formulario.requiereTipo) ...[
                          _buildSeccion('Tipo de servicio'),
                          _buildSelectorTipo(),
                          const SizedBox(height: 16),
                        ],
                        _buildSeccion('Datos del padre/madre'),
                        _buildCampo('Nombre completo', _nombrePadreCtrl),
                        _buildCampo('DNI', _nifPadreCtrl),
                        _buildCampo('Correo electrónico', _emailCtrl,
                            keyboardType: TextInputType.emailAddress),
                        _buildCampo('Teléfono', _telefonoCtrl,
                            keyboardType: TextInputType.phone),
                        if (widget.formulario.requiereIban) ...[
                          const SizedBox(height: 16),
                          _buildSeccion('Datos bancarios'),
                          _buildCampo('IBAN', _ibanCtrl),
                          _buildCampo('Titular de la cuenta', _titularCtrl),
                          _buildCampo('DNI del titular', _nifTitularCtrl),
                        ],
                        if (widget.formulario.condiciones.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildSeccion('Condiciones del servicio'),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.15)),
                            ),
                            child: Text(
                              widget.formulario.condiciones,
                              style: AppTextStyle.getOutfit400(
                                  textSize: 13,
                                  textColor: AppColors.secondary
                                      .withValues(alpha: 0.8)),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        _buildSeccion('Firma'),
                        _buildCampo('Nombre y apellidos (firma)',
                            _firmaCtrl),
                        const SizedBox(height: 24),
                        if (_tieneConflicto()) _buildAvisoConflicto(),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isEnviando || _tieneConflicto() ? null : _enviarSolicitud,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isEnviando
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: AppColors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    'Enviar solicitud',
                                    style: AppTextStyle.getOutfit600(
                                        textSize: 16,
                                        textColor: AppColors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        titulo,
        style: AppTextStyle.getOutfit600(
            textSize: 14, textColor: AppColors.secondary),
      ),
    );
  }

  Widget _buildCampo(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTextStyle.getOutfit400(
            textSize: 14, textColor: AppColors.secondary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyle.getOutfit400(
              textSize: 13,
              textColor: AppColors.secondary.withValues(alpha: 0.6)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColors.secondary.withValues(alpha: 0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColors.secondary.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorHijo() {
    if (datosPrecargados == null || datosPrecargados!.hijos.isEmpty) {
      return Text(
        'No se encontraron alumnos asociados',
        style: AppTextStyle.getOutfit400(
            textSize: 14,
            textColor: AppColors.secondary.withValues(alpha: 0.6)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
            color: AppColors.secondary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<HijoSolicitudModel>(
          value: hijoSeleccionado,
          isExpanded: true,
          style: AppTextStyle.getOutfit400(
              textSize: 14, textColor: AppColors.secondary),
          items: datosPrecargados!.hijos
              .map((h) => DropdownMenuItem(
                    value: h,
                    child: Text('${h.nombre} (${h.claseNombre})'),
                  ))
              .toList(),
          onChanged: (val) {
            setState(() => hijoSeleccionado = val);
          },
        ),
      ),
    );
  }

  Widget _buildSelectorTipo() {
    return Row(
      children: [
        _buildTipoOption('mensual', 'Mensual'),
        const SizedBox(width: 10),
        _buildTipoOption('dias_sueltos', 'Días sueltos'),
      ],
    );
  }

  Widget _buildTipoOption(String value, String label) {
    final bool selected = tipoSeleccionado == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tipoSeleccionado = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.secondary.withValues(alpha: 0.2),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyle.getOutfit600(
                  textSize: 14,
                  textColor:
                      selected ? AppColors.white : AppColors.secondary),
            ),
          ),
        ),
      ),
    );
  }

  bool _tieneConflicto() {
    if (hijoSeleccionado == null) return false;
    return _servicioYaContratado() ||
        widget.solicitudesExistentes.any((s) =>
            s.formularioId == widget.formulario.id &&
            s.studentId == hijoSeleccionado!.wpUsrId &&
            (s.estado == 'enviada' || s.estado == 'activa'));
  }

  bool _servicioYaContratado() {
    if (hijoSeleccionado == null) return false;
    return hijoSeleccionado!.yaContratado[widget.formulario.slug] == true;
  }

  SolicitudHistorialModel? _solicitudConflicto() {
    if (hijoSeleccionado == null) return null;
    try {
      return widget.solicitudesExistentes.firstWhere((s) =>
          s.formularioId == widget.formulario.id &&
          s.studentId == hijoSeleccionado!.wpUsrId &&
          (s.estado == 'enviada' || s.estado == 'activa'));
    } catch (_) {
      return null;
    }
  }

  Widget _buildAvisoConflicto() {
    final conflicto = _solicitudConflicto();
    final String msg;
    if (conflicto != null) {
      msg = conflicto.estado == 'activa'
          ? 'Este servicio ya está activo para ${hijoSeleccionado!.nombre}.'
          : 'Ya existe una solicitud enviada para ${hijoSeleccionado!.nombre}. Espera a que sea procesada o contacta con el centro.';
    } else if (_servicioYaContratado()) {
      msg = 'Servicio activo para ${hijoSeleccionado!.nombre} (alta tramitada en Secretaría).';
    } else {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              msg,
              style: AppTextStyle.getOutfit400(
                  textSize: 13, textColor: Colors.orange.shade800),
            ),
          ),
        ],
      ),
    );
  }
}