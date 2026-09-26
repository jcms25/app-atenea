import 'package:colegia_atenea/models/servicio_contratado_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';

class RecibosScreen extends StatefulWidget {
  const RecibosScreen({super.key});

  @override
  State<RecibosScreen> createState() => _RecibosScreenState();
}

class _RecibosScreenState extends State<RecibosScreen> {
  RecibosResponseModel? misRecibos;
  bool isLoadingRecibos = true;
  String? errorRecibos;
  final Set<String> _expandedCursos = {};
  final Set<int> _expandedRecibosNoDom = {};

  @override
  void initState() {
    super.initState();
    _loadMisRecibos();
  }

  Future<void> _loadMisRecibos() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final parentId = userdata?.parentWpUsrId ?? '';

      final response = await ApiClass().getServiciosContratadosMisRecibos(
        token: token,
        cookie: cookie,
        parentWpUsrId: parentId,
      );

      if (response['status'] == true) {
        final recibos = RecibosResponseModel.fromJson(response['data'] ?? {});
        setState(() {
          misRecibos = recibos;
          isLoadingRecibos = false;
          if (recibos.cursos.isNotEmpty) {
            _expandedCursos.add(recibos.cursos.first.academicYear);
          }
        });
      } else {
        setState(() {
          errorRecibos = response['Message'] ?? 'Error al cargar los recibos';
          isLoadingRecibos = false;
        });
      }
    } catch (e) {
      setState(() {
        errorRecibos = 'Error al cargar los recibos';
        isLoadingRecibos = false;
      });
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
                Text(
                  'Mis Recibos',
                  style: AppTextStyle.getOutfit600(
                      textSize: 22, textColor: AppColors.white),
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoadingRecibos) {
      return const Center(child: LoadingLayout());
    }
    if (errorRecibos != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            errorRecibos!,
            textAlign: TextAlign.center,
            style: AppTextStyle.getOutfit400(
                textSize: 15, textColor: AppColors.secondary),
          ),
        ),
      );
    }
    if (misRecibos == null || misRecibos!.cursos.isEmpty) {
      return Center(
        child: Text(
          'No hay recibos disponibles',
          style: AppTextStyle.getOutfit400(
              textSize: 16, textColor: AppColors.secondary),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => isLoadingRecibos = true);
        await _loadMisRecibos();
      },
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: misRecibos!.cursos.map(_buildCursoSection).toList(),
      ),
    );
  }

  Widget _buildCursoSection(CursoRecibosModel curso) {
    final bool expanded = _expandedCursos.contains(curso.academicYear);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (expanded) {
                  _expandedCursos.remove(curso.academicYear);
                } else {
                  _expandedCursos.add(curso.academicYear);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                children: [
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: AppColors.secondary.withValues(alpha: 0.6),
                    size: 22,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Curso ${curso.academicYear}',
                    style: AppTextStyle.getOutfit600(
                        textSize: 15, textColor: AppColors.secondary),
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            if (curso.domiciliados.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 6, top: 4),
                child: Text(
                  'Recibos domiciliados',
                  style: AppTextStyle.getOutfit400(
                      textSize: 12,
                      textColor: AppColors.secondary.withValues(alpha: 0.6)),
                ),
              ),
              _buildDomiciliadosTable(curso.domiciliados),
            ],
            if (curso.noDomiciliados.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 6, top: 10),
                child: Text(
                  'Recibos no domiciliados',
                  style: AppTextStyle.getOutfit400(
                      textSize: 12,
                      textColor: AppColors.secondary.withValues(alpha: 0.6)),
                ),
              ),
              ...curso.noDomiciliados.map(_buildReciboNoDomCard),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildDomiciliadosTable(List<ReciboMandatoModel> domiciliados) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: domiciliados.asMap().entries.map((entry) {
          final index = entry.key;
          final recibo = entry.value;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: index < domiciliados.length - 1
                  ? Border(
                      bottom: BorderSide(
                          color: AppColors.secondary.withValues(alpha: 0.08)),
                    )
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(recibo.fechaMandato),
                      style: AppTextStyle.getOutfit400(
                          textSize: 13,
                          textColor:
                              AppColors.secondary.withValues(alpha: 0.7)),
                    ),
                    Text(
                      _formatImporte(recibo.importeAdeudo),
                      style: AppTextStyle.getOutfit600(
                          textSize: 14, textColor: AppColors.secondary),
                    ),
                  ],
                ),
                if (recibo.concepto.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    recibo.concepto,
                    style: AppTextStyle.getOutfit400(
                        textSize: 12,
                        textColor: AppColors.secondary.withValues(alpha: 0.5)),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReciboNoDomCard(ReciboNoDomiciliadoModel recibo) {
    final bool expanded = _expandedRecibosNoDom.contains(recibo.idRecibo);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (expanded) {
                    _expandedRecibosNoDom.remove(recibo.idRecibo);
                  } else {
                    _expandedRecibosNoDom.add(recibo.idRecibo);
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(recibo.fechaRecibo),
                    style: AppTextStyle.getOutfit400(
                        textSize: 13,
                        textColor: AppColors.secondary.withValues(alpha: 0.7)),
                  ),
                  Row(
                    children: [
                      Text(
                        _formatImporte(recibo.totalRecibo),
                        style: AppTextStyle.getOutfit600(
                            textSize: 14, textColor: AppColors.secondary),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.secondary.withValues(alpha: 0.6),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (expanded && recibo.detalle.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...recibo.detalle.map((d) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      d.cantidad > 1
                          ? '${d.concepto} (x${d.cantidad}) — ${_formatImporte(d.total)}'
                          : '${d.concepto} — ${_formatImporte(d.total)}',
                      style: AppTextStyle.getOutfit400(
                          textSize: 12,
                          textColor:
                              AppColors.secondary.withValues(alpha: 0.6)),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  String _formatImporte(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    return '${parts[0]},${parts[1]} €';
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