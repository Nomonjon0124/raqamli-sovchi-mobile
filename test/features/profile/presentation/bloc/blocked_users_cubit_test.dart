import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/profile/application/use_cases/get_blocked_users.dart';
import 'package:raqamli_sovchi/features/profile/application/use_cases/unblock_user.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/blocked_user.dart';
import 'package:raqamli_sovchi/features/profile/domain/repositories/blocked_user_repository.dart';
import 'package:raqamli_sovchi/features/profile/presentation/bloc/blocked_users/blocked_users_cubit.dart';
import 'package:raqamli_sovchi/features/profile/presentation/bloc/blocked_users/blocked_users_state.dart';

final class _MockBlockedUserRepository extends Mock
    implements BlockedUserRepository {}

void main() {
  late _MockBlockedUserRepository mockRepository;
  late GetBlockedUsersUseCase getBlockedUsersUseCase;
  late UnblockUserUseCase unblockUserUseCase;
  late BlockedUsersCubit cubit;

  final sampleUser = BlockedUser(
    id: 'block-1',
    blocker: 'user-me',
    blocked: 'user-target',
    reason: 'spam',
    createdAt: DateTime(2026, 7, 28),
    blockedInfo: const BlockedUserInfo(
      id: 'user-target',
      profileId: 'profile-target',
      fullName: 'Aziz Karimov',
    ),
  );

  setUp(() {
    mockRepository = _MockBlockedUserRepository();
    getBlockedUsersUseCase = GetBlockedUsersUseCase(mockRepository);
    unblockUserUseCase = UnblockUserUseCase(mockRepository);
    cubit = BlockedUsersCubit(
      getBlockedUsers: getBlockedUsersUseCase,
      unblockUser: unblockUserUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('BlockedUsersCubit', () {
    test('initial state has correct defaults', () {
      expect(cubit.state.status, BlockedUsersStatus.initial);
      expect(cubit.state.blockedUsers, isEmpty);
      expect(cubit.state.unblockingUserIds, isEmpty);
    });

    blocTest<BlockedUsersCubit, BlockedUsersState>(
      'emits [loading, success] when loadBlockedUsers succeeds',
      build: () {
        when(
          () => mockRepository.getBlockedUsers(page: 1),
        ).thenAnswer((_) async => Right([sampleUser]));
        return cubit;
      },
      act: (cubit) => cubit.loadBlockedUsers(),
      expect: () => [
        const BlockedUsersState(status: BlockedUsersStatus.loading),
        BlockedUsersState(
          status: BlockedUsersStatus.success,
          blockedUsers: [sampleUser],
        ),
      ],
    );

    blocTest<BlockedUsersCubit, BlockedUsersState>(
      'emits [loading, failure] when loadBlockedUsers fails',
      build: () {
        when(
          () => mockRepository.getBlockedUsers(page: 1),
        ).thenAnswer((_) async => const Left(Failure.server()));
        return cubit;
      },
      act: (cubit) => cubit.loadBlockedUsers(),
      expect: () => [
        const BlockedUsersState(status: BlockedUsersStatus.loading),
        const BlockedUsersState(
          status: BlockedUsersStatus.failure,
          failure: Failure.server(),
        ),
      ],
    );

    blocTest<BlockedUsersCubit, BlockedUsersState>(
      'emits updated unblocking set then success with removed user when unblock succeeds',
      build: () {
        when(
          () => mockRepository.unblockUser(
            userId: 'user-target',
            blockedRecordId: 'block-1',
          ),
        ).thenAnswer((_) async => const Right(true));
        return cubit;
      },
      seed: () => BlockedUsersState(
        status: BlockedUsersStatus.success,
        blockedUsers: [sampleUser],
      ),
      act: (cubit) =>
          cubit.unblock(userId: 'user-target', blockedRecordId: 'block-1'),
      expect: () => [
        BlockedUsersState(
          status: BlockedUsersStatus.success,
          blockedUsers: [sampleUser],
          unblockingUserIds: const {'user-target'},
        ),
        const BlockedUsersState(
          status: BlockedUsersStatus.success,
          blockedUsers: [],
          unblockingUserIds: {},
          actionSuccessMessage: 'unblockSuccess',
        ),
      ],
    );

    blocTest<BlockedUsersCubit, BlockedUsersState>(
      'emits failure and restores unblocking set when unblock fails',
      build: () {
        when(
          () => mockRepository.unblockUser(
            userId: 'user-target',
            blockedRecordId: 'block-1',
          ),
        ).thenAnswer((_) async => const Left(Failure.server()));
        return cubit;
      },
      seed: () => BlockedUsersState(
        status: BlockedUsersStatus.success,
        blockedUsers: [sampleUser],
      ),
      act: (cubit) =>
          cubit.unblock(userId: 'user-target', blockedRecordId: 'block-1'),
      expect: () => [
        BlockedUsersState(
          status: BlockedUsersStatus.success,
          blockedUsers: [sampleUser],
          unblockingUserIds: const {'user-target'},
        ),
        BlockedUsersState(
          status: BlockedUsersStatus.success,
          blockedUsers: [sampleUser],
          unblockingUserIds: const {},
          failure: const Failure.server(),
        ),
      ],
    );
  });
}
