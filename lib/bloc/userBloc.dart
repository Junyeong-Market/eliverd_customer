import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:Eliverd/bloc/events/userEvent.dart';
import 'package:Eliverd/bloc/states/userState.dart';

import 'package:Eliverd/resources/repositories/repositories.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AccountRepository accountRepository;

  UserBloc({@required this.accountRepository})
      : assert(accountRepository != null),
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

      yield UserInfoFetched(
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
      final form = {
        'nickname': event.nickname,
        'realname': event.realname,
        'is_seller': event.isSeller,
      };

      final user = await accountRepository.getUser();
      final updated = await accountRepository.updateUser(user.pid, form);

      yield UserUpdated(
        nickname: updated['nickname'],
        realname: updated['realname'],
        isSeller: updated['is_seller'],
      );
    } catch (_) {
      yield UserError();
    }
  }

  Stream<UserState> _mapCloseUserAccountToState(CloseUserAccount event) async* {
    try {
      final user = await accountRepository.getUser();

      await accountRepository.closeUser(user.pid);

      yield UserClosed();
    } catch (_) {
      yield UserError();
    }
  }
}
