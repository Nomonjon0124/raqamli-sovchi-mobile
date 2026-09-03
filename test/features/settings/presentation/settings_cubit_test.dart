import 'package:bloc_test/bloc_test.dart';
import 'package:raqamli_sovchi/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:raqamli_sovchi/features/settings/presentation/cubit/settings_state.dart';

void main() {
  blocTest<SettingsCubit, SettingsState>(
    'updates the notifications preference',
    build: SettingsCubit.new,
    act: (cubit) => cubit.notificationsChanged(false),
    expect: () => const [SettingsState(notificationsEnabled: false)],
  );
}
