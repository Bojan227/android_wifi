import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_networks/blocs/bloc/wifi_bloc.dart';
import 'package:wifi_networks/data/wifi_provider.dart';
import 'package:wifi_networks/data/wifi_repo_impl.dart';
import 'package:wifi_networks/ui/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final WifiProvider wifiProvider = WifiProvider();
    final WifiRepository wifiRepository =
        WifiRepository(provider: wifiProvider);

    return MaterialApp(
      home: BlocProvider(
        create: (context) => WifiBloc(wifiRepository: wifiRepository),
        child: const HomeScreen(),
      ),
    );
  }
}
