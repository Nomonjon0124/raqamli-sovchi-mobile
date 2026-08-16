import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/api_client.dart';
import 'package:raqamli_sovchi/features/questionnaire/data/data_sources/questionnaire_data_source.dart';

void main() {
  test('maps questionnaire endpoints and bulk submission contract', () async {
    final client = _QuestionnaireApiClient();
    final dataSource = RemoteQuestionnaireDataSource(client);

    final profile = await dataSource.getMyProfile();
    final sections = await dataSource.getSections();
    final questions = await dataSource.getQuestions();
    final savedAnswers = await dataSource.getSavedAnswers(profile.id);
    await dataSource.submitAnswers(
      profileId: profile.id,
      answers: const {'question-1': 'option-b'},
    );

    expect(profile.id, 'profile-1');
    expect(profile.targetGender, 'groom');
    expect(sections.map((section) => section.name), ['First', 'Second']);
    expect(questions.single.sectionName, 'First');
    expect(questions.single.options.single.letter, 'B');
    expect(savedAnswers, const {'question-1': 'option-b'});
    expect(client.postPath, '/api/v1/accounts/answers/bulk-submit/');
    expect(client.postData, {
      'profile_id': 'profile-1',
      'answers': [
        {'question_id': 'question-1', 'selected_option_id': 'option-b'},
      ],
    });
  });
}

final class _QuestionnaireApiClient implements ApiClient {
  String? postPath;
  Object? postData;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final data = switch (path) {
      '/api/v1/accounts/profiles/me/' => {
        'data': {
          'id': 'profile-1',
          'candidate_type': 'groom',
          'gender': 'male',
        },
      },
      '/api/v1/accounts/section-types/' => {
        'data': {
          'next': null,
          'results': [
            {
              'id': 'section-2',
              'name': 'Second',
              'count': 1,
              'created_at': '2026-08-13T10:00:00Z',
            },
            {
              'id': 'section-1',
              'name': 'First',
              'count': 1,
              'created_at': '2026-08-12T10:00:00Z',
            },
          ],
        },
      },
      '/api/v1/accounts/questions/' => {
        'data': {
          'next': null,
          'results': [
            {
              'id': 'question-1',
              'text': 'Question?',
              'target_gender': 'all',
              'is_trap_question': false,
              'order': 1,
              'section_info': {'id': 'section-1', 'name': 'First'},
              'options_info': [
                {
                  'id': 'option-b',
                  'option_letter': 'B',
                  'text': 'Answer',
                  'weight': 5,
                },
              ],
            },
          ],
        },
      },
      '/api/v1/accounts/answers/' => {
        'data': {
          'next': null,
          'results': [
            {
              'question_info': {'id': 'question-1'},
              'selected_option_info': {'id': 'option-b'},
            },
          ],
        },
      },
      _ => <String, dynamic>{},
    };
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: data as T,
    );
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    postPath = path;
    postData = data;
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: <String, dynamic>{'data': const {}} as T,
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();

  @override
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();

  @override
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();
}
