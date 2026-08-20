abstract final class RouteNames {
  static const splash = '/';
  static const login = '/login';
  static const otp = '/otp';
  static const pinCreate = '/pin/create';
  static const pinUnlock = '/pin/unlock';
  static const onboarding = '/onboarding';
  static const questionnaire = '/questionnaire';
  static const home = '/home';
  static const messages = '/messages';
  static const services = '/services';
  static const saved = '/saved';
  static const profile = '/profile';
  static const candidateDetail = '/candidate-detail/:id';

  static String candidateDetailFor(String id) =>
      '/candidate-detail/${Uri.encodeComponent(id)}';
}
