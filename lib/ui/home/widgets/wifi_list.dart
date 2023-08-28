import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_networks/blocs/bloc/wifi_bloc.dart';
import 'package:wifi_networks/ui/home/widgets/wifi_item.dart';
import 'package:wifi_networks/ui/widgets/snackbar.dart';

class WifiList extends StatelessWidget {
  const WifiList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WifiBloc, WifiState>(
      listener: (context, state) {
        if (state.connectionStatus == Status.success) {
          showSnackBar(
              context, 'Connected to ${state.currentWifiAccessPoint?.ssid}');
        }
      },
      builder: (context, state) {
        if (state.status == Status.loading ||
            state.connectionStatus == Status.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.status == Status.failure) {
          return Center(
            child: Text(state.errorMessage ?? ""),
          );
        }

        if (state.accessPoints.isEmpty) {
          return const Center(
            child: Text('Scan to get available wifi networks'),
          );
        }

        if (state.status == Status.success) {
          return Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return WifiItem(accessPoint: state.accessPoints[index]);
              },
              itemCount: state.accessPoints.length,
            ),
          );
        }
        return Container();
      },
    );
  }
}
