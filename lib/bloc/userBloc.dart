import 'package:Eliverd/models/models.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:Eliverd/bloc/events/userEvent.dart';
import 'package:Eliverd/bloc/states/userState.dart';

import 'package:Eliverd/resources/repositories/repositories.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AccountRepository accountRepository;
  final ImageRepository imageRepository;

  UserBloc({@required this.accountRepository, @required this.imageRepository})
      : assert(accountRepository != null),
        assert(imageRepository != null),
        super(UserInitial());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is FetchUserInfo) {
      yield* _mapFetchUserInfoToState(event);
    } else if (event is UpdateUser) {
      yield* _mapUpdateUserToState(event);
    } else if (event is CloseUserAccount) {
      yield* _mapCloseUserAccountToState(event);
    }
  }

  Stream<UserState> _mapFetchUserInfoToState(FetchUserInfo event) async* {
    try {
      final user = await accountRepository.getUser();
      final summary =
          await accountRepository.fetchUserOrderSummary(user.pid, event.month);

      yield UserFetched(
        user: user,
        count: summary['count'],
        total: summary['total'],
      );
    } catch (_) {
      yield UserError();
    }
  }

  Stream<UserState> _mapUpdateUserToState(UpdateUser event) async* {
    try {
      final previous = await accountRepository.getUser();

      Asset profile = previous.profile;

      if (event.image != null) {
        profile = await imageRepository.uploadImage(event.image);
      }

      final form = {
        'nickname': event.nickname,
        'realname': event.realname,
        'profile': profile.id,
      };

      final updates = await accountRepository.updateUser(previous.pid, form);

      final user = previous.copyWith(
        $realname: updates['realname'],
        $nickname: updates['nickname'],
        $profile: updates['profile'],
      );

      final summary =
          await accountRepository.fetchUserOrderSummary(user.pid, 0);

      yield UserFetched(
        user: user,
        count: summary['count'],
        total: summary['total'],
      );
    } catch (_) {
      yield UserError();
    }
  }

  Stream<UserState> _mapCloseUserAccountToState(CloseUserAccount event) async* {
    try {
      final user = await accountRepository.getUser();

      await accountRepository.closeUser(user.pid);
    } catch (_) {
      yield UserError();
    }
  }
}
