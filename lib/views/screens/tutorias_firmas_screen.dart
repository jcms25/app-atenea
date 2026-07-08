import 'package:colegia_atenea/models/tutoria_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';

class TutoriasFirmasScreen extends StatefulWidget {
  const TutoriasFirmasScreen({super.key});

  @override
  State<TutoriasFirmasScreen> createState() => _TutoriasFirmasScreenState();
}

class _TutoriasFirmasScreenState extends State<TutoriasFirmasScreen> {
  List<TutoriaFirmaModel> pendientes = [];
  bool isLoading = true;

  String get _wpUsrId {
    final userdata = AppSharedPreferences.getUserData();
    final role = AppSharedPreferences.getUserLoggedInRole();
    if (role == 'parent') {
      return userdata?.parentWpUsrId ?? '';
    }
    return userdata?.wpUsrId ?? '';
  }

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => isLoading = true);
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

      final response = await ApiClass().getTutoriasFirmaPendientes(
        token: token,
        cookie: cookie,
        wpUsrId: _wpUsrId,
      );

      if (response['status'] == true) {
        final List data = response['pendientes'] ?? [];
        setState(() {
          pendientes = TutoriaFirmaModel.listFromJson(data);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _firmar(TutoriaFirmaModel firma) async {
    final nombreController = TextEditingController(text: firma.nombre);

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Firmar Acta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alumno/a: ${firma.alumnoNombre ?? ''}'),
            const SizedBox(height: 8),
            if (firma.asuntosTratados != null && firma.asuntosTratados!.isNotEmpty) ...[
              const Text('Asuntos tratados:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(firma.asuntosTratados!),
              const SizedBox(height: 8),
            ],
            if (firma.observaciones != null && firma.observaciones!.isNotEmpty) ...[
              const Text('Observaciones:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(firma.observaciones!),
              const SizedBox(height: 8),
            ],
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre y apellidos (firma)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Firmar')),
        ],
      ),
    );

    if (confirmar != true) return;
    if (!mounted) return;
    if (nombreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre es obligatorio para firmar')),
      );
      return;
    }

    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

    final response = await ApiClass().firmarTutoriaActa(
      token: token,
      cookie: cookie,
      firmaId: firma.id.toString(),
      wpUsrId: _wpUsrId,
      firmaNombre: nombreController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) _cargar();
    }
  }

  String _formatFecha(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
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
            child: Column(
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios, color: AppColors.white, size: 22),
                      ),
                      const SizedBox(width: 10),
                      Text('Firmas Pendientes',
                          style: AppTextStyle.getOutfit600(textSize: 22, textColor: AppColors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: LoadingLayout())
                : pendientes.isEmpty
                    ? Center(
                        child: Text(
                          'No tienes firmas pendientes',
                          style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _cargar,
                        color: AppColors.primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: pendientes.length,
                          itemBuilder: (context, index) {
                            final firma = pendientes[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                                boxShadow: [
                                  BoxShadow(color: AppColors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(firma.alumnoNombre ?? '',
                                        style: AppTextStyle.getOutfit600(textSize: 15, textColor: AppColors.secondary)),
                                    const SizedBox(height: 4),
                                    Text('Fecha: ${_formatFecha(firma.fechaPropuesta)}',
                                        style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () => _firmar(firma),
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                        child: Text('Firmar acta',
                                            style: AppTextStyle.getOutfit600(textSize: 13, textColor: AppColors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}