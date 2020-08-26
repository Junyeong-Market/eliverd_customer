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
    if (event is FetchUser) {
      yield* _mapFetchUserToState(event);
    } else if (event is UpdateUser) {
      yield* _mapUpdateUserToState(event);
    } else if (event is CloseUserAccount) {
      yield* _mapCloseUserAccountToState(event);
    }
  }

  Stream<UserState> _mapFetchUserToState(FetchUser event) async* {
    try {
      final user = await accountRepository.getUser();

      yield UserFetched(user);
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

      final pid = (await accountRepository.getUser()).pid;

      final updated = await accountRepository.updateUser(pid, form);

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
      final pid = (await accountRepository.getUser()).pid;

      await accountRepository.closeUser(pid);

      yield UserClosed();
    } catch (_) {
      yield UserError();
    }
  }
}
