import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_networks/blocs/bloc/wifi_bloc.dart';
import 'package:wifi_networks/data/models/connection_info.dart';
import 'package:wifi_networks/ui/widgets/snackbar.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../widgets/input_field.dart';

class WifiItem extends StatefulWidget {
  const WifiItem({super.key, required this.accessPoint});

  final WiFiAccessPoint accessPoint;

  @override
  State<WifiItem> createState() => _WifiItemState();
}

class _WifiItemState extends State<WifiItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String newMessage = '';

  void onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final ConnectionInfo connectionInfo = ConnectionInfo(
          ssid: widget.accessPoint.ssid,
          bssid: widget.accessPoint.bssid,
          password: newMessage);

      context.read<WifiBloc>().add(
            ConnetToWifiNetwork(connectionInfo: connectionInfo),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signalIcon = widget.accessPoint.level >= -80
        ? Icons.signal_wifi_4_bar
        : Icons.signal_wifi_0_bar;

    final title = widget.accessPoint.ssid.isNotEmpty
        ? widget.accessPoint.ssid
        : "**EMPTY**";

    final ConnectionInfo? currentConnectionInfo =
        context.watch<WifiBloc>().state.currentWifiAccessPoint;

    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(signalIcon),
      title: Text(title),
      trailing: currentConnectionInfo?.ssid == title
          ? ElevatedButton(
              onPressed: () {
                context.read<WifiBloc>().add(const DisconnectFromWifiNetwork());
                showSnackBar(context,
                    'Disconnected from ${currentConnectionInfo?.ssid}');
              },
              child: const Text('Disconnect'))
          : null,
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: _formKey,
                    child: InputField(
                        handleInput: (value) => newMessage = value,
                        obscureText: false,
                        label: 'Message'),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextButton(
                      onPressed: () {
                        onSubmit(context);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Connect'))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
