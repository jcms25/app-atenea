import 'package:colegia_atenea/models/tutoria_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';

/// Bottom sheet para seleccionar los asistentes al Acta de una tutoría,
/// organizados por categoría (Familia, Alumnado, Profesorado, Equipo Directivo).
/// Devuelve un TutoriaAsistentesSeleccionModel, o null si se cancela.
Future<TutoriaAsistentesSeleccionModel?> showTutoriaAsistentesSheet(
  BuildContext context, {
  required String tutoriaId,
  TutoriaAsistentesSeleccionModel? seleccionInicial,
}) {
  return showModalBottomSheet<TutoriaAsistentesSeleccionModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _TutoriaAsistentesContent(
      tutoriaId: tutoriaId,
      seleccionInicial: seleccionInicial,
    ),
  );
}

class _TutoriaAsistentesContent extends StatefulWidget {
  final String tutoriaId;
  final TutoriaAsistentesSeleccionModel? seleccionInicial;

  const _TutoriaAsistentesContent({required this.tutoriaId, this.seleccionInicial});

  @override
  State<_TutoriaAsistentesContent> createState() => _TutoriaAsistentesContentState();
}

class _TutoriaAsistentesContentState extends State<_TutoriaAsistentesContent> {
  bool _isLoading = true;
  TutoriaAsistentesSelectorModel? _selector;

  final Set<int> _familiaSeleccionada = {};
  final Set<int> _alumnadoSeleccionado = {};
  final Set<int> _profesoradoSeleccionado = {};
  final Set<int> _equipoDirectivoSeleccionado = {};
  bool _mostrarOtrosProfesores = false;
  final Set<int> _otrosProfesoresSeleccionados = {};

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

      final response = await ApiClass().getTutoriasAsistentesSelector(
        token: token,
        cookie: cookie,
        tutoriaId: widget.tutoriaId,
      );

      if (response['status'] == true) {
        setState(() {
          _selector = TutoriaAsistentesSelectorModel.fromJson(response);
          _isLoading = false;
        });
        // Pre-marcar selección inicial si venimos de editar
        final inicial = widget.seleccionInicial;
        if (inicial != null) {
          _familiaSeleccionada.addAll(inicial.familia.map((p) => p.wpUsrId));
          _alumnadoSeleccionado.addAll(inicial.alumnado.map((p) => p.wpUsrId));
          _profesoradoSeleccionado.addAll(inicial.profesorado.map((p) => p.wpUsrId));
          _equipoDirectivoSeleccionado.addAll(inicial.equipoDirectivo.map((p) => p.wpUsrId));
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _confirmar() {
    if (_selector == null) return;

    TutoriaAsistentePersonaModel? buscar(List<TutoriaAsistentePersonaModel> lista, int id) {
      try {
        return lista.firstWhere((p) => p.wpUsrId == id);
      } catch (_) {
        return null;
      }
    }

    final profesoradoFinal = <TutoriaAsistentePersonaModel>[];
    for (final id in _profesoradoSeleccionado) {
      final p = buscar(_selector!.profesorado, id);
      if (p != null) profesoradoFinal.add(p);
    }
    for (final id in _otrosProfesoresSeleccionados) {
      final p = buscar(_selector!.otrosProfesores, id);
      if (p != null) profesoradoFinal.add(p);
    }

    final resultado = TutoriaAsistentesSeleccionModel(
      familia: _selector!.familia.where((p) => _familiaSeleccionada.contains(p.wpUsrId)).toList(),
      alumnado: _selector!.alumnado.where((p) => _alumnadoSeleccionado.contains(p.wpUsrId)).toList(),
      profesorado: profesoradoFinal,
      equipoDirectivo: _selector!.equipoDirectivo.where((p) => _equipoDirectivoSeleccionado.contains(p.wpUsrId)).toList(),
    );

    Navigator.pop(context, resultado);
  }

  Widget _buildCategoria(String titulo, List<TutoriaAsistentePersonaModel> personas, Set<int> seleccionados) {
    if (personas.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: AppTextStyle.getOutfit600(textSize: 13, textColor: AppColors.primary)),
      ...personas.map((p) {
          return CheckboxListTile(
            dense: true,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 0,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(p.nombre, style: AppTextStyle.getOutfit400(textSize: 13, textColor: AppColors.secondary)),
            value: seleccionados.contains(p.wpUsrId),
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  seleccionados.add(p.wpUsrId);
                } else {
                  seleccionados.remove(p.wpUsrId);
                }
              });
            },
          );
        }),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Seleccionar asistentes', style: AppTextStyle.getOutfit600(textSize: 18, textColor: AppColors.secondary)),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _selector == null
                        ? const Center(child: Text('No se pudo cargar la información'))
                        : ListView(
                            controller: scrollController,
                            children: [
                              _buildCategoria('Familia', _selector!.familia, _familiaSeleccionada),
                              _buildCategoria('Alumnado', _selector!.alumnado, _alumnadoSeleccionado),
                              _buildCategoria('Profesorado', _selector!.profesorado, _profesoradoSeleccionado),
                              if (_selector!.otrosProfesores.isNotEmpty) ...[
                                InkWell(
                                  onTap: () => setState(() => _mostrarOtrosProfesores = !_mostrarOtrosProfesores),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        Icon(_mostrarOtrosProfesores ? Icons.expand_less : Icons.expand_more, size: 18, color: AppColors.primary),
                                        const SizedBox(width: 4),
                                        Text('Otros profesores del centro',
                                            style: AppTextStyle.getOutfit600(textSize: 13, textColor: AppColors.primary)),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_mostrarOtrosProfesores)
                                  ..._selector!.otrosProfesores.map((p) {
                                    return CheckboxListTile(
                                      dense: true,
                                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                      contentPadding: EdgeInsets.zero,
                                      minVerticalPadding: 0,
                                      controlAffinity: ListTileControlAffinity.leading,
                                      title: Text(
                                        p.bajaLaboral ? '${p.nombre} (baja laboral)' : p.nombre,
                                        style: AppTextStyle.getOutfit400(
                                          textSize: 13,
                                          textColor: p.bajaLaboral ? AppColors.secondary.withValues(alpha: 0.4) : AppColors.secondary,
                                        ),
                                      ),
                                      value: _otrosProfesoresSeleccionados.contains(p.wpUsrId),
                                      onChanged: p.bajaLaboral
                                          ? null
                                          : (checked) {
                                              setState(() {
                                                if (checked == true) {
                                                  _otrosProfesoresSeleccionados.add(p.wpUsrId);
                                                } else {
                                                  _otrosProfesoresSeleccionados.remove(p.wpUsrId);
                                                }
                                              });
                                            },
                                    );
                                  }),
                                const SizedBox(height: 12),
                              ],
                              _buildCategoria('Equipo Directivo', _selector!.equipoDirectivo, _equipoDirectivoSeleccionado),
                            ],
                          ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmar,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('Confirmar asistentes'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}