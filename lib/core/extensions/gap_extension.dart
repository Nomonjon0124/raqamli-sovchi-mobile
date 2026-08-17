import 'package:gap/gap.dart';

extension GapExtension on num {
  Gap get g => Gap(toDouble());
}
