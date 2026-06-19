import 'dart:convert';
import 'package:colegia_atenea/models/autorizacion_model.dart';
import 'package:colegia_atenea/services/api.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

enum ModoEnvio { plantilla, libre }

class AutorizacionTutorEnviarScreen extends StatefulWidget {
  final AutorizacionTutorClaseModel claseTutoria;

  const AutorizacionTutorEnviarScreen({super.key, required this.claseTutoria});

  @override
  State<AutorizacionTutorEnviarScreen> createState() =>
      _AutorizacionTutorEnviarScreenState();
}

class _AutorizacionTutorEnviarScreenState
    extends State<AutorizacionTutorEnviarScreen> {
  ModoEnvio modo = ModoEnvio.plantilla;

  bool isLoadingPlantillas = true;
  List<AutorizacionPlantillaModel> plantillas = [];
  AutorizacionPlantillaModel? plantillaSeleccionada;
  bool previewExpandido = false;

  // Modo libre
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();
  bool guardarComoPlantilla = false;
  final TextEditingController _nombrePlantillaController = TextEditingController();

  // Alumnos
  late Set<int> alumnosSeleccionados;

  bool isSending = false;

  @override
  void initState() {
    super.initState();
    // Por defecto, todos los alumnos de la clase seleccionados
    alumnosSeleccionados =
        widget.claseTutoria.alumnos.map((a) => a.wpUsrId).toSet();
    _loadPlantillas();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    _nombrePlantillaController.dispose();
    super.dispose();
  }

  Future<void> _loadPlantillas() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final teacherId = userdata?.wpUsrId ?? '';

      final response = await Api.httpRequest(
        requestType: RequestType.get,
        endPoint: "${Api.autorizacionesTutorPlantillasEndPoint}?teacher_wp_usr_id=$teacherId",
        header: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Authorization': 'Basic $token',
          'Cookie': cookie,
        },
      );

      if (response['status'] == true) {
        final List data = response['data'] ?? [];
        setState(() {
          plantillas = data
              .map((e) => AutorizacionPlantillaModel.fromJson(e))
              .toList();
          isLoadingPlantillas = false;
        });
      } else {
        setState(() => isLoadingPlantillas = false);
      }
    } catch (e) {
      setState(() => isLoadingPlantillas = false);
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
                    'Enviar autorización · ${widget.claseTutoria.cName}',
                    style: AppTextStyle.getOutfit600(
                        textSize: 18, textColor: AppColors.white),
                    maxLines: 1,
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
                  _buildModoSelector(),
                  const SizedBox(height: 16),
                  if (modo == ModoEnvio.plantilla)
                    _buildPlantillaSection()
                  else
                    _buildLibreSection(),
                  const SizedBox(height: 20),
                  _buildAlumnosSection(),
                  const SizedBox(height: 24),
                  _buildEnviarButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModoSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => modo = ModoEnvio.plantilla),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: modo == ModoEnvio.plantilla
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Usar plantilla',
                    style: AppTextStyle.getOutfit600(
                        textSize: 14,
                        textColor: modo == ModoEnvio.plantilla
                            ? AppColors.white
                            : AppColors.primary),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => modo = ModoEnvio.libre),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: modo == ModoEnvio.libre
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Escribir nueva',
                    style: AppTextStyle.getOutfit600(
                        textSize: 14,
                        textColor: modo == ModoEnvio.libre
                            ? AppColors.white
                            : AppColors.primary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantillaSection() {
    if (isLoadingPlantillas) {
      return const Center(child: LoadingLayout());
    }
    if (plantillas.isEmpty) {
      return Text(
        'No hay plantillas disponibles.',
        style: AppTextStyle.getOutfit400(
            textSize: 14, textColor: AppColors.secondary.withValues(alpha: 0.6)),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona una plantilla',
          style: AppTextStyle.getOutfit600(
              textSize: 14, textColor: AppColors.secondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AutorizacionPlantillaModel>(
              isExpanded: true,
              value: plantillaSeleccionada,
              hint: Text('Selecciona...',
                  style: AppTextStyle.getOutfit400(
                      textSize: 14,
                      textColor: AppColors.secondary.withValues(alpha: 0.5))),
              items: plantillas
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(
                          p.plantillaNombre,
                          style: AppTextStyle.getOutfit400(
                              textSize: 14, textColor: AppColors.secondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  plantillaSeleccionada = value;
                  previewExpandido = false;
                });
              },
            ),
          ),
        ),
        if (plantillaSeleccionada != null) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => previewExpandido = !previewExpandido),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Vista previa',
                      style: AppTextStyle.getOutfit600(
                          textSize: 13, textColor: AppColors.primary),
                    ),
                  ),
                  Icon(
                    previewExpandido
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
            crossFadeState: previewExpandido
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: Html(
                data: plantillaSeleccionada!.contenidoPreview
                    .replaceAll('\r\n', '<br>'),
                style: {
                  'body': Style(
                    fontSize: FontSize(13),
                    fontFamily: 'Outfit',
                    color: AppColors.secondary,
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                },
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ],
    );
  }

  Widget _buildLibreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Título',
          style: AppTextStyle.getOutfit600(
              textSize: 14, textColor: AppColors.secondary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _tituloController,
          decoration: InputDecoration(
            hintText: 'Título de la autorización',
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
              textSize: 14, textColor: AppColors.secondary),
        ),
        const SizedBox(height: 16),
        Text(
          'Contenido',
          style: AppTextStyle.getOutfit600(
              textSize: 14, textColor: AppColors.secondary),
        ),
        const SizedBox(height: 6),
        _buildFormatToolbar(),
        const SizedBox(height: 6),
        TextField(
          controller: _contenidoController,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: 'Escribe el contenido de la autorización...',
            hintStyle: AppTextStyle.getOutfit400(
                textSize: 14,
                textColor: AppColors.secondary.withValues(alpha: 0.4)),
            contentPadding: const EdgeInsets.all(12),
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
              textSize: 14, textColor: AppColors.secondary),
        ),
        const SizedBox(height: 4),
        Text(
          'Puedes usar variables: {{alumno_nombre}}, {{padre_nombre}}, {{clase_nombre}}, {{etapa}}, {{año_academico}}, {{tutor}}, {{director}}',
          style: AppTextStyle.getOutfit400(
              textSize: 11,
              textColor: AppColors.secondary.withValues(alpha: 0.5)),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: guardarComoPlantilla,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() => guardarComoPlantilla = value ?? false);
              },
            ),
            Expanded(
              child: Text(
                'Guardar como plantilla para usarla en el futuro',
                style: AppTextStyle.getOutfit400(
                    textSize: 13, textColor: AppColors.secondary),
              ),
            ),
          ],
        ),
        if (guardarComoPlantilla) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _nombrePlantillaController,
            decoration: InputDecoration(
              hintText: 'Nombre de la plantilla (opcional, por defecto el título)',
              hintStyle: AppTextStyle.getOutfit400(
                  textSize: 13,
                  textColor: AppColors.secondary.withValues(alpha: 0.4)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            style: AppTextStyle.getOutfit400(
                textSize: 13, textColor: AppColors.secondary),
          ),
        ],
      ],
    );
  }

  Widget _buildFormatToolbar() {
    return Row(
      children: [
        _buildFormatButton(
          icon: Icons.format_bold,
          tooltip: 'Negrita',
          onTap: () => _wrapSelection('<strong>', '</strong>'),
        ),
        const SizedBox(width: 8),
        _buildFormatButton(
          icon: Icons.format_italic,
          tooltip: 'Cursiva',
          onTap: () => _wrapSelection('<em>', '</em>'),
        ),
        const SizedBox(width: 8),
        _buildFormatButton(
          icon: Icons.format_align_center,
          tooltip: 'Centrar',
          onTap: () => _wrapSelection(
              '<div style="text-align: center">', '</div>'),
        ),
      ],
    );
  }

  Widget _buildFormatButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
      ),
    );
  }

  void _wrapSelection(String openTag, String closeTag) {
    final text = _contenidoController.text;
    final selection = _contenidoController.selection;

    if (!selection.isValid || selection.isCollapsed) {
      // Sin selección: insertar las etiquetas en la posición del cursor
      final cursor = selection.baseOffset >= 0 ? selection.baseOffset : text.length;
      final newText = text.replaceRange(cursor, cursor, '$openTag$closeTag');
      _contenidoController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: cursor + openTag.length),
      );
      return;
    }

    final start = selection.start;
    final end = selection.end;
    final selectedText = text.substring(start, end);
    final newText = text.replaceRange(
        start, end, '$openTag$selectedText$closeTag');

    _contenidoController.value = TextEditingValue(
      text: newText,
      selection: TextSelection(
        baseOffset: start,
        extentOffset: end + openTag.length + closeTag.length,
      ),
    );
  }

  Widget _buildAlumnosSection() {
    final alumnos = widget.claseTutoria.alumnos;
    final allSelected = alumnosSeleccionados.length == alumnos.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Alumnos (${alumnosSeleccionados.length}/${alumnos.length})',
                style: AppTextStyle.getOutfit600(
                    textSize: 14, textColor: AppColors.secondary),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (allSelected) {
                    alumnosSeleccionados.clear();
                  } else {
                    alumnosSeleccionados =
                        alumnos.map((a) => a.wpUsrId).toSet();
                  }
                });
              },
              child: Text(
                allSelected ? 'Quitar todos' : 'Marcar todos',
                style: AppTextStyle.getOutfit600(
                    textSize: 13, textColor: AppColors.primary),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alumnos.length,
            separatorBuilder: (_, __) => Divider(
                height: 1, color: AppColors.primary.withValues(alpha: 0.08)),
            itemBuilder: (context, index) {
              final alumno = alumnos[index];
              final selected = alumnosSeleccionados.contains(alumno.wpUsrId);
              return CheckboxListTile(
                value: selected,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppColors.primary,
                title: Text(
                  alumno.nombreCompleto,
                  style: AppTextStyle.getOutfit400(
                      textSize: 14, textColor: AppColors.secondary),
                ),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      alumnosSeleccionados.add(alumno.wpUsrId);
                    } else {
                      alumnosSeleccionados.remove(alumno.wpUsrId);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEnviarButton() {
    return GestureDetector(
      onTap: isSending ? null : _enviar,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: isSending
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: AppColors.white, strokeWidth: 2),
                )
              : Text(
                  'Enviar autorización',
                  style: AppTextStyle.getOutfit600(
                      textSize: 15, textColor: AppColors.white),
                ),
        ),
      ),
    );
  }

  Future<void> _enviar() async {    
    if (alumnosSeleccionados.isEmpty) {
      AppConstants.showCustomToast(
          status: false, message: 'Selecciona al menos un alumno');
      return;
    }

    if (modo == ModoEnvio.plantilla && plantillaSeleccionada == null) {
      AppConstants.showCustomToast(
          status: false, message: 'Selecciona una plantilla');
      return;
    }

    if (modo == ModoEnvio.libre &&
        (_tituloController.text.trim().isEmpty ||
            _contenidoController.text.trim().isEmpty)) {
      AppConstants.showCustomToast(
          status: false, message: 'El título y el contenido son obligatorios');
      return;
    }

    setState(() => isSending = true);

    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final teacherId = userdata?.wpUsrId ?? '';

      final alumnosJson = jsonEncode(alumnosSeleccionados.toList());

      final Map<String, String> body = {
        'teacher_wp_usr_id': teacherId,
        'modo': modo == ModoEnvio.plantilla ? 'plantilla' : 'libre',
        'guardar_como_plantilla': guardarComoPlantilla ? '1' : '0',
        'alumnos': alumnosJson,
      };
      if (modo == ModoEnvio.plantilla && plantillaSeleccionada != null) {
        body['plantilla_id'] = '${plantillaSeleccionada!.id}';
      }
      if (modo == ModoEnvio.libre) {
        body['titulo'] = _tituloController.text.trim();
        body['contenido'] = _contenidoController.text.trim();
      }
      if (guardarComoPlantilla && _nombrePlantillaController.text.trim().isNotEmpty) {
        body['plantilla_nombre'] = _nombrePlantillaController.text.trim();
      }

      final response = await Api.httpRequest(
        requestType: RequestType.post,
        endPoint: Api.autorizacionesTutorEnviarEndPoint,
        header: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Authorization': 'Basic $token',
          'Cookie': cookie,
        },
        body: body,
      );

      setState(() => isSending = false);

      if (response['status'] == true) {
        final enviados = response['alumnos_enviados'] ?? alumnosSeleccionados.length;
        AppConstants.showCustomToast(
            status: true,
            message: 'Autorización enviada a $enviados alumno(s)');
        if (mounted) Navigator.pop(context, true);
      } else {
        AppConstants.showCustomToast(
            status: false, message: response['Message'] ?? response['message'] ?? 'Error al enviar');
      }
    } catch (e) {
      debugPrint('TUTOR ENVIAR exception: $e');
      setState(() => isSending = false);
      AppConstants.showCustomToast(status: false, message: 'Error: $e');
    }
  }
}