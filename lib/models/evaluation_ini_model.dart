class EvaluationIniItem {
  final String subject;
  final String topic;
  final String mark;
  final String remark;

  EvaluationIniItem({
    required this.subject,
    required this.topic,
    required this.mark,
    required this.remark,
  });

  factory EvaluationIniItem.fromJson(Map<String, dynamic> json) {
    return EvaluationIniItem(
      subject: json['subject']?.toString() ?? '',
      topic: json['topic']?.toString() ?? '',
      mark: json['mark']?.toString() ?? '',
      remark: json['remark']?.toString() ?? '',
    );
  }
}