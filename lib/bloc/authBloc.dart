import 'package:Eliverd/common/string.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:Eliverd/bloc/events/authEvent.dart';
import 'package:Eliverd/bloc/states/authState.dart';

import 'package:Eliverd/resources/repositories/repositories.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AccountRepository accountRepository;

  AuthenticationBloc({@required this.accountRepository})
      : assert(accountRepository != null),
        super(NotAuthenticated());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is CheckAuthentication) {
      yield* _mapCheckAuthenticationToState(event);
    } else if (event is GrantAuthentication) {
      yield* _mapGrantAuthenticationToState(event);
    } else if (event is RevokeAuthentication) {
      yield* _mapRevokeAuthenticationToState(event);
    }
  }

  Stream<AuthenticationState> _mapCheckAuthenticationToState(
      CheckAuthentication event) async* {
    try {
      final user = await accountRepository.validateSession();

      if (user == null) {
        yield NotAuthenticated();

        return;
      }

      yield Authenticated(user);
    } catch (_) {
      yield NotAuthenticated();
    }
  }

  Stream<AuthenticationState> _mapGrantAuthenticationToState(
      GrantAuthentication event) async* {
    try {
      final session =
          await accountRepository.createSession(event.userId, event.password);

      if (session == null) {
        yield NotAuthenticated();

        return;
      }

      final user = await accountRepository.validateSession();

      if (user == null) {
        yield NotAuthenticated();

        return;
      }

      yield Authenticated(user);
    } catch (_) {
      yield AuthenticationError(ErrorMessages.loginErrorMessage);
    }
  }

  Stream<AuthenticationState> _mapRevokeAuthenticationToState(
      RevokeAuthentication event) async* {
    try {
      await accountRepository.deleteSession();

      yield NotAuthenticated();
    } catch (_) {
      yield AuthenticationError(ErrorMessages.loginErrorMessage);
    }
  }
}
