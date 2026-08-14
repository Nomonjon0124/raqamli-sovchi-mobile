import '../../../../core/network/api_client.dart';
import '../models/questionnaire_models.dart';

abstract interface class QuestionnaireDataSource {
  Future<QuestionnaireProfileModel> getMyProfile();

  Future<List<QuestionnaireSectionModel>> getSections();

  Future<List<QuestionnaireQuestionModel>> getQuestions();

  Future<Map<String, String>> getSavedAnswers(String profileId);

  Future<void> submitAnswers({
    required String profileId,
    required Map<String, String> answers,
  });
}

final class RemoteQuestionnaireDataSource implements QuestionnaireDataSource {
  const RemoteQuestionnaireDataSource(this._client);

  static const _profilePath = '/api/v1/accounts/profiles/me/';
  static const _sectionsPath = '/api/v1/accounts/section-types/';
  static const _questionsPath = '/api/v1/accounts/questions/';
  static const _answersPath = '/api/v1/accounts/answers/';
  static const _bulkSubmitPath = '/api/v1/accounts/answers/bulk-submit/';

  final ApiClient _client;

  @override
  Future<QuestionnaireProfileModel> getMyProfile() async {
    final response = await _client.get<Map<String, dynamic>>(_profilePath);
    return QuestionnaireProfileModel.fromJson(_payload(response.data));
  }

  @override
  Future<List<QuestionnaireSectionModel>> getSections() async {
    final values = await _getAllPages(_sectionsPath);
    final sections = values
        .map(QuestionnaireSectionModel.fromJson)
        .toList(growable: false);
    sections.sort((left, right) => left.createdAt.compareTo(right.createdAt));
    return sections;
  }

  @override
  Future<List<QuestionnaireQuestionModel>> getQuestions() async {
    final values = await _getAllPages(_questionsPath);
    final questions = values
        .map(QuestionnaireQuestionModel.fromJson)
        .toList(growable: false);
    questions.sort((left, right) => left.order.compareTo(right.order));
    return questions;
  }

  @override
  Future<Map<String, String>> getSavedAnswers(String profileId) async {
    final values = await _getAllPages(
      _answersPath,
      queryParameters: {'profile': profileId},
    );
    return {
      for (final value in values)
        if (_map(value['question_info'])['id'] != null &&
            _map(value['selected_option_info'])['id'] != null)
          _map(value['question_info'])['id'].toString(): _map(
            value['selected_option_info'],
          )['id'].toString(),
    };
  }

  @override
  Future<void> submitAnswers({
    required String profileId,
    required Map<String, String> answers,
  }) async {
    await _client.post<Map<String, dynamic>>(
      _bulkSubmitPath,
      data: {
        'profile_id': profileId,
        'answers': [
          for (final answer in answers.entries)
            {'question_id': answer.key, 'selected_option_id': answer.value},
        ],
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getAllPages(
    String path, {
    Map<String, dynamic> queryParameters = const {},
  }) async {
    final items = <Map<String, dynamic>>[];
    var page = 1;
    while (true) {
      final response = await _client.get<Map<String, dynamic>>(
        path,
        queryParameters: {...queryParameters, 'page': page},
      );
      final payload = _payload(response.data);
      final results = payload['results'];
      if (results is List) {
        items.addAll(results.whereType<Map>().map(_map));
      }
      if (payload['next'] == null || results is! List || results.isEmpty) {
        break;
      }
      page++;
    }
    return items;
  }
}

Map<String, dynamic> _payload(Map<String, dynamic>? response) {
  final value = response ?? const <String, dynamic>{};
  final data = value['data'];
  return data is Map ? _map(data) : value;
}

Map<String, dynamic> _map(Map value) {
  return value.map((key, item) => MapEntry(key.toString(), item));
}
