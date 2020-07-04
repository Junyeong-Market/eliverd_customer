import 'package:Eliverd/common/string.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:Eliverd/bloc/events/authEvent.dart';
import 'package:Eliverd/bloc/states/authState.dart';

import 'package:Eliverd/models/models.dart';
import 'package:Eliverd/resources/repositories/repositories.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AccountRepository accountRepository;

  AuthenticationBloc(
      {@required this.accountRepository})
      : assert(accountRepository != null);

  @override
  AuthenticationState get initialState => NotAuthenticated();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is ValidateAuthentication) {
      yield* _mapValidateAuthenticationToState(event);
    } else if (event is CheckAuthentication) {
      yield* _mapCheckAuthenticationToState(event);
    } else if (event is GrantAuthentication) {
      yield* _mapGrantAuthenticationToState(event);
    } else if (event is RevokeAuthentication) {
      yield* _mapRevokeAuthenticationToState(event);
    }
  }

  Stream<AuthenticationState> _mapValidateAuthenticationToState(
      ValidateAuthentication event) async* {
    try {
      final data = await accountRepository.validateSession();

      if (data.isEmpty) {
        yield NotAuthenticated();
      }

      final authenticatedUser = User(
        userId: data['user_id'],
        nickname: data['nickname'],
        realname: data['realname'],
        isSeller: data['is_seller'],
      );

      yield Authenticated(authenticatedUser);
    } catch (_) {
      yield AuthenticationError(ErrorMessages.loginErrorMessage);
    }
  }

  Stream<AuthenticationState> _mapCheckAuthenticationToState(
      CheckAuthentication event) async* {
    final session = await accountRepository.createSession();

    if (session != null) {
      final data = await accountRepository.validateSession();

      if (data['is_seller'] == false) {
        yield AuthenticationError(ErrorMessages.disallowedToManageStoreMessage);
      }

      final authenticatedUser = User(
        userId: data['user_id'],
        nickname: data['nickname'],
        realname: data['realname'],
        isSeller: data['is_seller'],
      );

      yield Authenticated(authenticatedUser);
    }
  }

  Stream<AuthenticationState> _mapGrantAuthenticationToState(
      GrantAuthentication event) async* {
    try {
      final session =
          await accountRepository.createSession(event.userId, event.password);

      if (session == null) {
        yield NotAuthenticated();
      }

      final data = await accountRepository.validateSession();

      if (data['is_seller'] == false) {
        yield AuthenticationError(ErrorMessages.disallowedToManageStoreMessage);
      }

      final authenticatedUser = User(
        userId: data['user_id'],
        nickname: data['nickname'],
        realname: data['realname'],
        isSeller: data['is_seller'],
      );

      yield Authenticated(authenticatedUser);
    } catch (e) {
      print(e.toString());
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
