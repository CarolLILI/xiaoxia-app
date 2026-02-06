/// 健康数据模型
class HealthData {
  final String id;
  final String type; // 'bmi', 'steps', 'water', 'sleep', 'weight'
  final double value;
  final String? unit;
  final DateTime date;
  final String? note;

  HealthData({
    required this.id,
    required this.type,
    required this.value,
    this.unit,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'value': value,
      'unit': unit,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory HealthData.fromMap(Map<String, dynamic> map) {
    return HealthData(
      id: map['id'],
      type: map['type'],
      value: map['value'],
      unit: map['unit'],
      date: DateTime.parse(map['date']),
      note: map['note'],
    );
  }
}

/// BMI 记录
class BMIRecord {
  final String id;
  final double height; // cm
  final double weight; // kg
  final double bmi;
  final DateTime date;

  BMIRecord({
    required this.id,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'date': date.toIso8601String(),
    };
  }

  factory BMIRecord.fromMap(Map<String, dynamic> map) {
    return BMIRecord(
      id: map['id'],
      height: map['height'],
      weight: map['weight'],
      bmi: map['bmi'],
      date: DateTime.parse(map['date']),
    );
  }

  /// 获取BMI状态
  String getStatus() {
    if (bmi < 18.5) return '偏瘦';
    if (bmi < 24) return '正常';
    if (bmi < 28) return '偏胖';
    return '肥胖';
  }

  /// 获取状态颜色
  String getStatusColor() {
    if (bmi < 18.5) return 'blue';
    if (bmi < 24) return 'green';
    if (bmi < 28) return 'orange';
    return 'red';
  }
}

/// 每日健康统计
class DailyHealthStats {
  final DateTime date;
  final int steps;
  final int water; // ml
  final double sleep; // hours
  final double? weight;

  DailyHealthStats({
    required this.date,
    this.steps = 0,
    this.water = 0,
    this.sleep = 0,
    this.weight,
  });
}
