import 'package:flutter/material.dart';

/// Nombre e icono de cada perfil de la app, en un solo sitio.
class PerfilVisual {
  static String etiqueta(String role) {
    switch (role) {
      case 'teacher':
        return 'Profesor';
      case 'parent':
        return 'Padre/Madre';
      case 'student':
        return 'Alumno';
      case 'assistant':
        return 'Asistencia';
      case 'secretaria':
        return 'Secretaría';
      case 'personal_no_docente':
        return 'Personal no docente';
      default:
        return role;
    }
  }

  static IconData icono(String role) {
    switch (role) {
      case 'teacher':
        return Icons.school;
      case 'parent':
        return Icons.family_restroom;
      case 'student':
        return Icons.person;
      case 'assistant':
        return Icons.assignment_ind;
      case 'secretaria':
        return Icons.badge;
      case 'personal_no_docente':
        return Icons.work;
      default:
        return Icons.person;
    }
  }
}
