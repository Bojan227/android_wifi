import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_networks/blocs/bloc/wifi_bloc.dart';
import 'package:wifi_networks/ui/home/widgets/wifi_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wifi Networks')),
      body: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.perm_scan_wifi),
            label: const Text('SCAN'),
            onPressed: () =>
                context.read<WifiBloc>().add(const ScanWifiNetworks()),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          const WifiList()
        ],
      ),
    );
  }
}
