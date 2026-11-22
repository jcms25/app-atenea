import 'package:colegia_atenea/controllers/assistant_controller.dart';
import 'package:colegia_atenea/controllers/splash_login_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/services/api.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_routes.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/utils/perfil_visual.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/screens/configuracion_screen.dart';
import 'package:colegia_atenea/views/screens/jornada_screen.dart';
import 'package:colegia_atenea/views/screens/jornada_historial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:colegia_atenea/main.dart';
import 'package:colegia_atenea/utils/jornada_deeplink.dart';

/// Escritorio y menú lateral de los perfiles `secretaria` y `personal_no_docente`.
/// Mismo estilo que el escritorio y el menú de Profesor.
class PersonalMainScreen extends StatefulWidget {
  const PersonalMainScreen({super.key});

  @override
  State<PersonalMainScreen> createState() => _PersonalMainScreenState();
}

class _PersonalMainScreenState extends State<PersonalMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _cerrando = false;
  
  Worker? _avisoJornada;

  @override
  void initState() {
    super.initState();
    // Aviso de fichaje: con la app recién abierta (cerrada antes) y con la app ya abierta
    WidgetsBinding.instance
        .addPostFrameCallback((_) => abrirJornadaSiPendiente());
    _avisoJornada = ever(pendingDeepLink, (_) => abrirJornadaSiPendiente());
  }

  @override
  void dispose() {
    _avisoJornada?.dispose();
    super.dispose();
  }

  String get _role => AppSharedPreferences.getUserLoggedInRole() ?? '';

  String get _nombre =>
      AppSharedPreferences.getUserData()?.firstName?.trim() ?? '';

  String get _foto => AppSharedPreferences.getUserData()?.teacherImage ?? '';

  // Icono de una opción del menú de Profesor, buscado por su nombre.
  String? _iconoMenu(String nombre) {
    for (final e in AppConstants.drawerListTeacher) {
      if (e['name'] == nombre) return e['icon'];
    }
    return null;
  }

  Widget _svg(String? ruta, IconData alternativo) {
    if (ruta == null) {
      return Icon(alternativo, color: AppColors.secondary, size: 25);
    }
    return SvgPicture.asset(
      ruta,
      colorFilter:
          const ColorFilter.mode(AppColors.secondary, BlendMode.srcIn),
      width: 25,
      height: 25,
    );
  }

  void _abrirJornada() {
    Get.to(() => const JornadaScreen());
  }

  Future<void> _cambiarPerfil(String nuevoRol) async {
    Navigator.of(context).pop();
    await context.read<SplashLoginController>().switchProfile(
          newRole: nuevoRol,
          studentParentTeacherController:
              context.read<StudentParentTeacherController>(),
          assistantController: context.read<AssistantController>(),
        );
  }

  Widget _botonDialogo(BuildContext ctx, String texto, bool valor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: AppColors.primary,
          elevation: 0.0),
      onPressed: () => Navigator.pop(ctx, valor),
      child: Text(texto,
          style: AppTextStyle.getOutfit400(
              textSize: 14, textColor: AppColors.white)),
    );
  }

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text('sure'.tr,
            style: AppTextStyle.getOutfit400(
                textSize: 18, textColor: AppColors.secondary)),
        actions: [
          _botonDialogo(ctx, 'negativeButton'.tr, false),
          _botonDialogo(ctx, 'positiveButton'.tr, true),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;
    setState(() => _cerrando = true);
    try {
      final userId = AppSharedPreferences.getUserData()?.wpUsrId ?? '';
      final response = await Api.httpRequest(
          requestType: RequestType.post,
          endPoint: Api.logoutEndPoint,
          body: <String, dynamic>{'user_id': userId});
      if (response['status'] == true) {
        await AppSharedPreferences.loggedOutUser();
        Get.offNamedUntil(AppRoutes.loginScreen, (routes) => false);
        return;
      }
      AppConstants.showCustomToast(
          status: false,
          message: response['Message'] ?? response['message'] ?? '');
    } catch (e) {
      AppConstants.showCustomToast(status: false, message: '$e');
    }
    if (mounted) setState(() => _cerrando = false);
  }

  Widget _avatar() {
    return SizedBox(
      height: 65,
      width: 65,
      child: _foto.isEmpty
          ? const CircleAvatar(backgroundImage: AssetImage(AppImages.people))
          : CircleAvatar(
              radius: 16.0,
              backgroundColor: AppColors.primary,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(65.0),
                child: Image.network(_foto,
                    fit: BoxFit.cover, height: 65, width: 65),
              ),
            ),
    );
  }

  Widget _opcion(
      {Widget? icono,
      required String titulo,
      required VoidCallback onTap}) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -1),
      leading: icono ?? const SizedBox.shrink(),
      title: Text(titulo,
          style: AppTextStyle.getOutfit500(
              textSize: 18, textColor: AppColors.secondary)),
      onTap: onTap,
    );
  }

  Widget _menu(BuildContext context) {
    final otrosPerfiles = AppSharedPreferences.getAvailableRoles()
        .where((r) => r != _role)
        .toList();

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.70,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            child: Row(
              children: [
                _avatar(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('hello'.tr,
                          style: AppTextStyle.getOutfit300(
                              textSize: 16, textColor: AppColors.white)),
                      Text(_nombre,
                          maxLines: 2,
                          style: AppTextStyle.getOutfit600(
                              textSize: 14, textColor: AppColors.white)),
                    ],
                  ),
                ),
                Image.asset(AppImages.whiteAppLogo, width: 50, height: 50),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _opcion(
                  icono: _svg(_iconoMenu('Escritorio'),
                      Icons.dashboard_outlined),
                  titulo: 'Escritorio',
                  onTap: () => Navigator.of(context).pop(),
                ),
                ExpansionTile(
                  visualDensity: const VisualDensity(vertical: -1),
                  leading: SvgPicture.asset(
                    AppImages.jornada,
                    colorFilter: const ColorFilter.mode(
                        AppColors.secondary, BlendMode.srcIn),
                    width: 25,
                    height: 25,
                  ),
                  collapsedIconColor: AppColors.secondary,
                  iconColor: AppColors.secondary,
                  title: Text('Mi jornada',
                      style: AppTextStyle.getOutfit500(
                          textSize: 18, textColor: AppColors.secondary)),
                  children: [
                    _opcion(
                      titulo: 'Mi jornada de hoy',
                      onTap: () {
                        Navigator.of(context).pop();
                        _abrirJornada();
                      },
                    ),
                    _opcion(
                      titulo: 'Histórico de jornada',
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() => const JornadaHistorialScreen());
                      },
                    ),
                  ],
                ),
                ListTile(
                  visualDensity: const VisualDensity(vertical: -1),
                  leading: const Icon(Icons.settings_outlined,
                      color: AppColors.secondary, size: 25),
                  title: Text('Configuración',
                      style: AppTextStyle.getOutfit500(
                          textSize: 18, textColor: AppColors.secondary)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(() => const ConfiguracionScreen());
                  },
                ),
              ],
            ),
          ),
          if (otrosPerfiles.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cambiar perfil',
                      style: AppTextStyle.getOutfit600(
                          textSize: 13, textColor: AppColors.primary)),
                  const SizedBox(height: 4),
                  ...otrosPerfiles.map((rol) {
                    return GestureDetector(
                      onTap: () => _cambiarPerfil(rol),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(PerfilVisual.icono(rol),
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(PerfilVisual.etiqueta(rol),
                                style: AppTextStyle.getOutfit400(
                                    textSize: 16,
                                    textColor: AppColors.black)),
                          ],
                        ),
                      ),
                    );
                  }),
                  const Divider(),
                ],
              ),
            ),
          CustomButtonWidget(
              buttonTitle: 'logout'.tr,
              suffixIcon: AppImages.loginArrow,
              margin: 10,
              onPressed: () {
                Navigator.of(context).pop();
                _cerrarSesion();
              }),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version =
                  snapshot.hasData ? 'v${snapshot.data!.version}' : '';
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  version,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontFamily: 'Outfit',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _encabezado(BuildContext context) {
    final variosPerfiles = AppSharedPreferences.getAvailableRoles().length > 1;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          8, MediaQuery.paddingOf(context).top + 8, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              const SizedBox(width: 4),
              Text('Escritorio',
                  style: AppTextStyle.getOutfit600(
                      textSize: 20, textColor: AppColors.white)),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                _avatar(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('hello'.tr,
                          style: AppTextStyle.getOutfit300(
                              textSize: 16, textColor: AppColors.white)),
                      Text(_nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.getOutfit600(
                              textSize: 20, textColor: AppColors.white)),
                    ],
                  ),
                ),
                if (variosPerfiles)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(PerfilVisual.icono(_role),
                          color: AppColors.white.withValues(alpha: 0.8),
                          size: 18),
                      Text(PerfilVisual.etiqueta(_role),
                          style: AppTextStyle.getOutfit300(
                              textSize: 11,
                              textColor:
                                  AppColors.white.withValues(alpha: 0.8))),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: _menu(context),
      body: Stack(
        children: [
          Column(
            children: [
              _encabezado(context),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _abrirJornada,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: AppColors.primary, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule,
                            size: 32, color: AppColors.primary),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mi jornada de hoy',
                                  style: AppTextStyle.getOutfit600(
                                      textSize: 17,
                                      textColor: AppColors.secondary)),
                              const SizedBox(height: 4),
                              Text('Ficha tu entrada y tu salida',
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 14,
                                      textColor: AppColors.secondary)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_cerrando)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x66000000),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
