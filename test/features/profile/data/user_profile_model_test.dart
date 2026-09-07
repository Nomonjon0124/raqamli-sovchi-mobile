import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/profile/data/models/user_profile_model.dart';

void main() {
  test('maps the profile response used by the profile screen', () {
    final birthDate = DateTime(DateTime.now().year - 22, 1, 1);
    final model = UserProfileModel.fromJson({
      'id': '13f6728f-64f7-4cb1-a351-1234abcdef90',
      'has_answered_test': 'true',
      'answered_questions_count': '18',
      'first_name': 'Safarali',
      'last_name': 'Muxtorov',
      'birth_date': birthDate.toIso8601String().split('T').first,
      'gender': 'male',
      'height': 180,
      'bio': null,
      'is_verified': true,
      'region_info': {'id': 'region-id', 'name': 'Toshkent'},
      'district_info': {'id': 'district-id', 'name': 'Yunusobod'},
      'education_level_info': {'id': 'education-id', 'name': 'Oliy'},
      'profession_info': {'id': 'profession-id', 'name': 'Muhandis'},
      'user_info': {
        'id': 'user-id',
        'phone_number': '+998901234567',
        'email': 'user@example.com',
      },
      'photos_info': [
        {
          'id': 'second',
          'image': 'https://example.com/second.jpg',
          'is_main': false,
          'order': 2,
        },
        {
          'id': 'main',
          'image': 'https://example.com/main.jpg',
          'is_main': true,
          'order': 3,
        },
      ],
    });

    final profile = model.toEntity();

    expect(profile.displayName, 'Safarali Muxtorov');
    expect(profile.age, 22);
    expect(profile.birthDate, birthDate);
    expect(profile.birthYear, birthDate.year);
    expect(profile.initials, 'SM');
    expect(profile.publicCode, 'CDEF90');
    expect(profile.hasAnsweredTest, isTrue);
    expect(profile.answeredQuestionsCount, 18);
    expect(profile.isVerified, isTrue);
    expect(profile.mainPhoto?.id, 'main');
    expect(profile.photos.map((photo) => photo.id), ['main', 'second']);
    expect(profile.regionId, 'region-id');
    expect(profile.districtId, 'district-id');
    expect(profile.educationLevelId, 'education-id');
    expect(profile.professionId, 'profession-id');
    expect(profile.completionPercent, 91);
  });
}
