import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/services/biometric_service.dart';
import 'package:colegia_atenea/services/secure_credentials_service.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  bool _biometricEnabled = AppSharedPreferences.getBiometricEnabled();

  Future<void> _onBiometricChanged(bool value) async {
    if (!value) {
      try {
        await SecureCredentialsService.clearCredentials();
      } catch (_) {
        AppConstants.showCustomToast(
            status: false,
            message:
                'No se pudo desactivar el acceso con huella/cara. Inténtalo de nuevo.');
        return;
      }
      await AppSharedPreferences.saveBiometricEnabled(enabled: false);
      if (!mounted) return;
      setState(() => _biometricEnabled = false);
      return;
    }

    if (!await BiometricService.isAvailable()) {
      AppConstants.showCustomToast(
          status: false,
          message:
              'Este dispositivo no tiene huella, cara ni bloqueo de pantalla configurado.');
      return;
    }

    final Map<String, dynamic>? credentials =
        AppSharedPreferences.getActiveUserCredential();
    final String userName = credentials?['userName'] ?? '';
    final String userPassword = credentials?['userPassword'] ?? '';
    final String? userRole = AppSharedPreferences.getUserLoggedInRole();
    if (userName.isEmpty || userPassword.isEmpty || userRole == null) {
      AppConstants.showCustomToast(
          status: false,
          message:
              'Para activar esta opción, cierra sesión y vuelve a iniciarla.');
      return;
    }

    // Confirmación antes de activar, para no dejar activado un acceso
    // que luego no funcione.
    final bool confirmed = await BiometricService.authenticate(
        reason: 'Confirma tu identidad para activar el acceso con huella o cara');
    if (!confirmed) return;

    try {
      await SecureCredentialsService.saveCredentials(
        userName: userName,
        userPassword: userPassword,
        userRole: userRole,
      );
    } catch (_) {
      AppConstants.showCustomToast(
          status: false,
          message:
              'No se pudo activar el acceso con huella/cara. Inténtalo de nuevo.');
      return;
    }

    await AppSharedPreferences.saveBiometricEnabled(enabled: true);
    if (!mounted) return;
    setState(() => _biometricEnabled = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBarWidget(
        title: Text(
          'Configuración',
          style: AppTextStyle.getOutfit600(
              textSize: 20, textColor: AppColors.white),
        ),
        onLeadingIconClicked: () => Get.back(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _biometricEnabled,
            onChanged: _onBiometricChanged,
            title: Text(
              'Acceso con huella/cara',
              style: AppTextStyle.getOutfit500(
                  textSize: 18, textColor: AppColors.secondary),
            ),
            subtitle: Text(
              'Podrás iniciar sesión con tu huella, tu cara o el PIN del móvil, sin escribir tu contraseña.',
              style: AppTextStyle.getOutfit400(
                  textSize: 14, textColor: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
