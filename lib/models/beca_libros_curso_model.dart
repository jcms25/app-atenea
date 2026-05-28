// Modelo del módulo Becas — respuesta de GET /beca/libros-curso/{student_id}

class BecaLibrosCursoResponse {
  final bool status;
  final String curso;
  final List<BecaLibroCurso> data;

  BecaLibrosCursoResponse({
    required this.status,
    required this.curso,
    required this.data,
  });

  factory BecaLibrosCursoResponse.fromJson(Map<String, dynamic> json) {
    return BecaLibrosCursoResponse(
      status: json['status'] ?? false,
      curso: json['curso'] ?? '',
      data: json['data'] != null
          ? List<BecaLibroCurso>.from(
              (json['data'] as List).map((e) => BecaLibroCurso.fromJson(e)))
          : <BecaLibroCurso>[],
    );
  }
}

class BecaLibroCurso {
  final String asignatura;
  final String titulo;
  final String editorial;
  final String isbn;

  BecaLibroCurso({
    required this.asignatura,
    required this.titulo,
    required this.editorial,
    required this.isbn,
  });

  factory BecaLibroCurso.fromJson(Map<String, dynamic> json) {
    return BecaLibroCurso(
      asignatura: json['asignatura'] ?? '',
      titulo: json['titulo'] ?? '',
      editorial: json['editorial'] ?? '',
      isbn: json['isbn'] ?? '',
    );
  }
}