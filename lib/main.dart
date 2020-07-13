import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:Eliverd/resources/providers/providers.dart';
import 'package:Eliverd/resources/repositories/repositories.dart';

import 'package:Eliverd/bloc/authBloc.dart';
import 'package:Eliverd/bloc/storeBloc.dart';

import 'package:Eliverd/common/theme.dart';

import 'package:Eliverd/ui/pages/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = EliverdBlocDelegate();

  runApp(EliverdCustomer());
}

class EliverdCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(
            accountRepository: AccountRepository(
              accountAPIClient: AccountAPIClient(
                httpClient: http.Client(),
              ),
            ),
          ),
        ),
        BlocProvider<StoreBloc>(
          create: (_) => StoreBloc(
            storeRepository: StoreRepository(
              storeAPIClient: StoreAPIClient(
                httpClient: http.Client(),
              ),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: eliverdTheme,
        home: SplashScreenPage(),
      ),
    );
  }
}

class EliverdBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print('onEvent $event');
    super.onEvent(bloc, event);
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    print('onTransition $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print('onError $error');
    super.onError(bloc, error, stackTrace);
  }
}
