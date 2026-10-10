import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';

/// Desplegable con el mismo aspecto que "Ver historial de conversación":
/// flecha pequeña a la izquierda del texto y contenido sin sangrado.
class TutoriaDesplegableWidget extends StatefulWidget {
  final String titulo;
  final List<Widget> children;

  const TutoriaDesplegableWidget({
    super.key,
    required this.titulo,
    required this.children,
  });

  @override
  State<TutoriaDesplegableWidget> createState() => _TutoriaDesplegableWidgetState();
}

class _TutoriaDesplegableWidgetState extends State<TutoriaDesplegableWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.titulo,
                  style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...widget.children,
      ],
    );
  }
}