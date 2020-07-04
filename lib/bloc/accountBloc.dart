import 'package:meta/meta.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Eliverd/resources/repositories/repositories.dart';

import 'package:Eliverd/bloc/events/accountEvent.dart';
import 'package:Eliverd/bloc/states/accountState.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository accountRepository;

  AccountBloc({@required this.accountRepository})
      : assert(accountRepository != null);

  @override
  AccountState get initialState => AccountInitial();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is CreateAccount) {
      yield* _mapCreateAccountToState(event);
    } else if (event is ValidateAccount) {
      yield* _mapValidateAccountToState(event);
    }
  }

  Stream<AccountState> _mapCreateAccountToState(CreateAccount event) async* {
    try {
      if (state is! AccountValidateFailed) {
        await accountRepository.signUpUser(event.jsonifiedUser);

        yield AccountDoneCreate();
      }
    } catch (_) {
      yield AccountError();
    }
  }

  Stream<AccountState> _mapValidateAccountToState(ValidateAccount event) async* {
    try {
      yield AccountOnCreate();

      final validation = await accountRepository.validateUser(event.jsonifiedUser);

      if (validation.values.any((value) => value is List)) {
        yield AccountValidateFailed(validation);
      }
    } catch (_) {
      yield AccountError();
    }
  }
}
