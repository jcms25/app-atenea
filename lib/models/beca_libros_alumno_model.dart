// Modelo del módulo Becas — respuesta de GET /beca/libros-alumno/{student_id}

class BecaLibrosAlumnoResponse {
  final bool status;
  final String anioAcademico;
  final List<BecaLibro> data;

  BecaLibrosAlumnoResponse({
    required this.status,
    required this.anioAcademico,
    required this.data,
  });

  factory BecaLibrosAlumnoResponse.fromJson(Map<String, dynamic> json) {
    return BecaLibrosAlumnoResponse(
      status: json['status'] ?? false,
      anioAcademico: json['anio_academico'] ?? '',
      data: json['data'] != null
          ? List<BecaLibro>.from(
              (json['data'] as List).map((e) => BecaLibro.fromJson(e)))
          : <BecaLibro>[],
    );
  }
}

class BecaLibro {
  final String asignatura;
  final String titulo;
  final String isbn;
  final String modo; // 'Usado' | 'Nuevo'

  BecaLibro({
    required this.asignatura,
    required this.titulo,
    required this.isbn,
    required this.modo,
  });

  factory BecaLibro.fromJson(Map<String, dynamic> json) {
    return BecaLibro(
      asignatura: json['asignatura'] ?? '',
      titulo: json['titulo'] ?? '',
      isbn: json['isbn'] ?? '',
      modo: json['modo'] ?? '',
    );
  }

  /// true si el libro es usado (banco de libros)
  bool get isUsado => modo.toLowerCase() == 'usado';
}