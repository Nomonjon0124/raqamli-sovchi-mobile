import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_keypad.dart';

enum PinPageMode { create, unlock }

enum _PinSetupStep { create, confirm }

final class PinPage extends StatefulWidget {
  const PinPage({required this.mode, super.key});

  final PinPageMode mode;

  @override
  State<PinPage> createState() => _PinPageState();
}

final class _PinPageState extends State<PinPage> {
  String _value = '';
  String? _initialPin;
  _PinSetupStep _setupStep = _PinSetupStep.create;
  bool _hasPinMismatch = false;
  bool _requestedBiometricAvailability = false;
  bool _requestedBiometricUnlock = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.mode == PinPageMode.unlock && !_requestedBiometricAvailability) {
      _requestedBiometricAvailability = true;
      context.read<AuthBloc>().add(const AuthBiometricAvailabilityRequested());
    }
  }

  void _requestBiometricUnlockIfReady(AuthState authState) {
    if (widget.mode != PinPageMode.unlock ||
        _requestedBiometricUnlock ||
        !authState.biometricAvailable ||
        authState.status != AuthStatus.pinLocked) {
      return;
    }
    _requestedBiometricUnlock = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthBloc>().add(const AuthBiometricUnlockRequested());
    });
  }

  void _addDigit(String digit) {
    if (_value.length >= 4) return;
    final nextValue = '$_value$digit';
    setState(() {
      _value = nextValue;
      _hasPinMismatch = false;
    });
    if (nextValue.length == 4) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _onPinCompleted(nextValue),
      );
    }
  }

  void _removeDigit() {
    if (_value.isEmpty) return;
    setState(() => _value = _value.substring(0, _value.length - 1));
  }

  void _onPinCompleted(String pin) {
    if (!mounted || _value != pin) return;

    if (widget.mode == PinPageMode.unlock) {
      context.read<AuthBloc>().add(AuthPinUnlockRequested(pin));
      return;
    }

    if (_setupStep == _PinSetupStep.create) {
      setState(() {
        _initialPin = pin;
        _setupStep = _PinSetupStep.confirm;
        _value = '';
        _hasPinMismatch = false;
      });
      return;
    }

    if (_initialPin != pin) {
      setState(() {
        _initialPin = null;
        _setupStep = _PinSetupStep.create;
        _value = '';
        _hasPinMismatch = true;
      });
      return;
    }

    context.read<AuthBloc>().add(AuthPinCreated(pin));
  }

  void _onAuthStateChanged(AuthState state) {
    if (state.status == AuthStatus.pinSetupRequired ||
        state.status == AuthStatus.pinLocked) {
      if (_value.isNotEmpty) setState(() => _value = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    _requestBiometricUnlockIfReady(authState);
    final isCreate = widget.mode == PinPageMode.create;
    final isConfirming = isCreate && _setupStep == _PinSetupStep.confirm;
    final isLoading = authState.status == AuthStatus.loading;
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status == AuthStatus.loading &&
          current.status != AuthStatus.loading,
      listener: (_, state) => _onAuthStateChanged(state),
      child: Scaffold(
        backgroundColor: AppColors.surfaceLight,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.lg,
              AppSpacing.screen,
              AppSpacing.xl,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: AuthBackButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthFlowCancelled());
                      context.go(RouteNames.login);
                    },
                  ),
                ),
                const Spacer(),
                Text(
                  isConfirming
                      ? l10n.pinConfirmTitle
                      : isCreate
                      ? l10n.pinCreateTitle
                      : l10n.pinUnlockTitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.pinTitle,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  isConfirming
                      ? l10n.pinHintConfirm
                      : isCreate
                      ? l10n.pinHintCreate
                      : l10n.pinHintUnlock,
                  textAlign: TextAlign.center,
                  style: AppTypography.onboardingBody,
                ),
                const SizedBox(height: AppSpacing.xxl),
                _PinIndicator(valueLength: _value.length),
                if (_hasPinMismatch) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.pinMismatch,
                    textAlign: TextAlign.center,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.dangerText,
                    ),
                  ),
                ],
                if (authState.failure != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.failureMessage(authState.failure!.type.name),
                    textAlign: TextAlign.center,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.dangerText,
                    ),
                  ),
                ],
                const Spacer(),
                AbsorbPointer(
                  absorbing: isLoading,
                  child: Opacity(
                    opacity: isLoading ? 0.5 : 1,
                    child: AuthKeypad(
                      onDigit: _addDigit,
                      onBackspace: _removeDigit,
                      showFingerprint:
                          !isCreate && authState.biometricAvailable,
                      onFingerprint: () => context.read<AuthBloc>().add(
                        const AuthBiometricUnlockRequested(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _PinIndicator extends StatelessWidget {
  const _PinIndicator({required this.valueLength});

  final int valueLength;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (var index = 0; index < 4; index++) ...[
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < valueLength ? AppColors.primary : AppColors.border,
          ),
        ),
        if (index != 3) const SizedBox(width: AppSpacing.input),
      ],
    ],
  );
}
