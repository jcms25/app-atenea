class OrderDetailModel {
  bool? status;
  String? message;
  List<Products>? products;
  List<String>? billings;
  List<Others>? others;

  OrderDetailModel(
      {this.status, this.message, this.products, this.billings, this.others});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['Products'] != null) {
      products = <Products>[];
      json['Products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    billings = json['Billings'].cast<String>();
    if (json['Others'] != null) {
      others = <Others>[];
      json['Others'].forEach((v) {
        others!.add(Others.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (products != null) {
      data['Products'] = products!.map((v) => v.toJson()).toList();
    }
    data['Billings'] = billings;
    if (others != null) {
      data['Others'] = others!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ComponenteLote {
  String nombre;
  int porLote;
  int total;
  bool pendiente;
  int pendienteQty;
  String entregado;

  ComponenteLote.fromJson(Map<String, dynamic> json)
      : nombre = json['nombre']?.toString() ?? '',
        porLote = (json['por_lote'] as num?)?.toInt() ?? 0,
        total = (json['total'] as num?)?.toInt() ?? 0,
        pendiente = json['pendiente'] == true,
        pendienteQty = (json['pendiente_qty'] as num?)?.toInt() ?? 0,
        entregado = json['entregado']?.toString() ?? '';
}

class Products {
  int? productId;
  int? variationId;
  String? productName;
  int? quantity;
  double? total;
  bool esComponente = false;
  int reembolsadas = 0;
  int lotes = 0;
  int pendienteQty = 0;
  List<ComponenteLote> componentes = [];

  Products(
      {this.productId,
        this.variationId,
        this.productName,
        this.quantity,
        this.total});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    variationId = json['variation_id'];
    productName = json['product_name'];
    quantity = json['quantity'];
    total = json['total'].toDouble();
    esComponente = json['es_componente'] == true;
    reembolsadas = (json['reembolsadas'] as num?)?.toInt() ?? 0;
    lotes = (json['lotes'] as num?)?.toInt() ?? 0;
    pendienteQty = (json['pendiente_qty'] as num?)?.toInt() ?? 0;
    componentes = (json['componentes'] as List?)
            ?.map((c) => ComponenteLote.fromJson(c as Map<String, dynamic>))
            .toList() ??
        [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['variation_id'] = variationId;
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['total'] = total;
    return data;
  }
}

class Reembolso {
  double importe;
  String motivo;

  Reembolso.fromJson(Map<String, dynamic> json)
      : importe = (json['importe'] as num?)?.toDouble() ?? 0,
        motivo = json['motivo']?.toString() ?? '';
}

class Others {
  String? orderId;
  String? date;
  String? total;
  String? paymentMethod;
  String? status;
  dynamic nIF;
  dynamic student;
  dynamic courso;
  DatosBancarios? datosBancarios;
  double totalReembolsado = 0;
  double? totalNeto;
  List<Reembolso> reembolsos = [];
  Others(
      {this.orderId,
        this.date,
        this.total,
        this.paymentMethod,
        this.status,
        this.nIF,
        this.student,
        this.courso,
        this.datosBancarios});

  Others.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    date = json['date'];
    total = json['total'];
    paymentMethod = json['payment_method'];
    status = json['status'];
    nIF = json['NIF'];
    student = json['Student'];
    courso = json['Courso'].runtimeType == List ? json['Courso'].cast<String>() : json['Courso'];
    datosBancarios = json['datos_bancarios'] != null
        ? DatosBancarios.fromJson(json['datos_bancarios'])
        : null;
    totalReembolsado = (json['total_reembolsado'] as num?)?.toDouble() ?? 0;
    totalNeto = (json['total_neto'] as num?)?.toDouble();
    reembolsos = (json['reembolsos'] as List?)
            ?.map((r) => Reembolso.fromJson(r as Map<String, dynamic>))
            .toList() ??
        [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['date'] = date;
    data['total'] = total;
    data['payment_method'] = paymentMethod;
    data['status'] = status;
    data['NIF'] = nIF;
    data['Student'] = student;
    data['Courso'] = courso;
    if (datosBancarios != null) {
      data['datos_bancarios'] = datosBancarios!.toJson();
    }
    return data;
  }
}

class DatosBancarios {
  String? accountName;
  String? bankName;
  String? accountNumber;
  String? sortCode;
  String? iban;
  String? bic;
  String? concepto;
  String? importe;

  DatosBancarios(
      {this.accountName,
      this.bankName,
      this.accountNumber,
      this.sortCode,
      this.iban,
      this.bic,
      this.concepto,
      this.importe});

  DatosBancarios.fromJson(Map<String, dynamic> json) {
    accountName = json['account_name'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    sortCode = json['sort_code'];
    iban = json['iban'];
    bic = json['bic'];
    concepto = json['concepto'];
    importe = json['importe']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_name'] = accountName;
    data['bank_name'] = bankName;
    data['account_number'] = accountNumber;
    data['sort_code'] = sortCode;
    data['iban'] = iban;
    data['bic'] = bic;
    data['concepto'] = concepto;
    data['importe'] = importe;
    return data;
  }
}
