import '../../domain/entities/questionnaire.dart';

final class QuestionnaireSectionModel {
  const QuestionnaireSectionModel({
    required this.id,
    required this.name,
    required this.questionCount,
    required this.createdAt,
  });

  factory QuestionnaireSectionModel.fromJson(Map<String, dynamic> json) {
    return QuestionnaireSectionModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      questionCount: int.tryParse((json['count'] ?? 0).toString()) ?? 0,
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }

  final String id;
  final String name;
  final int questionCount;
  final DateTime createdAt;

  QuestionnaireSection toEntity({int? effectiveQuestionCount}) {
    return QuestionnaireSection(
      id: id,
      name: name,
      questionCount: effectiveQuestionCount ?? questionCount,
    );
  }
}

final class QuestionnaireOptionModel {
  const QuestionnaireOptionModel({
    required this.id,
    required this.letter,
    required this.text,
    required this.weight,
  });

  factory QuestionnaireOptionModel.fromJson(Map<String, dynamic> json) {
    return QuestionnaireOptionModel(
      id: (json['id'] ?? '').toString(),
      letter: (json['option_letter'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
      weight: int.tryParse((json['weight'] ?? 0).toString()) ?? 0,
    );
  }

  final String id;
  final String letter;
  final String text;
  final int weight;

  QuestionnaireOption toEntity() {
    return QuestionnaireOption(
      id: id,
      letter: letter,
      text: text,
      weight: weight,
    );
  }
}

final class QuestionnaireQuestionModel {
  const QuestionnaireQuestionModel({
    required this.id,
    required this.sectionId,
    required this.sectionName,
    required this.text,
    required this.targetGender,
    required this.isTrapQuestion,
    required this.order,
    required this.options,
  });

  factory QuestionnaireQuestionModel.fromJson(Map<String, dynamic> json) {
    final section = _map(json['section_info']);
    final options = json['options_info'];
    return QuestionnaireQuestionModel(
      id: (json['id'] ?? '').toString(),
      sectionId: (section['id'] ?? '').toString(),
      sectionName: (section['name'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
      targetGender: (json['target_gender'] ?? 'all').toString(),
      isTrapQuestion: json['is_trap_question'] == true,
      order: int.tryParse((json['order'] ?? 0).toString()) ?? 0,
      options: options is List
          ? options
                .whereType<Map>()
                .map((item) => QuestionnaireOptionModel.fromJson(_map(item)))
                .toList(growable: false)
          : const [],
    );
  }

  final String id;
  final String sectionId;
  final String sectionName;
  final String text;
  final String targetGender;
  final bool isTrapQuestion;
  final int order;
  final List<QuestionnaireOptionModel> options;

  QuestionnaireQuestion toEntity() {
    return QuestionnaireQuestion(
      id: id,
      sectionId: sectionId,
      sectionName: sectionName,
      text: text,
      order: order,
      isTrapQuestion: isTrapQuestion,
      options: options
          .map((option) => option.toEntity())
          .toList(growable: false),
    );
  }
}

final class QuestionnaireProfileModel {
  const QuestionnaireProfileModel({
    required this.id,
    required this.candidateType,
    required this.gender,
  });

  factory QuestionnaireProfileModel.fromJson(Map<String, dynamic> json) {
    return QuestionnaireProfileModel(
      id: (json['id'] ?? '').toString(),
      candidateType: (json['candidate_type'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
    );
  }

  final String id;
  final String candidateType;
  final String gender;

  String? get targetGender {
    if (candidateType == 'groom' || candidateType == 'bride') {
      return candidateType;
    }
    return switch (gender) {
      'male' => 'groom',
      'female' => 'bride',
      _ => null,
    };
  }
}

Map<String, dynamic> _map(Object? value) {
  if (value is! Map) return const {};
  return value.map((key, item) => MapEntry(key.toString(), item));
}
