import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

void main() {
  runApp(const MyApp());
}

/// Example app for wifi_scan plugin.
class MyApp extends StatefulWidget {
  /// Default constructor for [MyApp] widget.
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  bool shouldCheckCan = true;
  bool isConnected = false;

  Future<void> _startScan(BuildContext context) async {
    // check if "can" startScan
    if (shouldCheckCan) {
      // check if can-startScan
      final can = await WiFiScan.instance.canStartScan();

      // if can-not, then show error
      if (can != CanStartScan.yes) {
        if (mounted) kShowSnackBar(context, "Cannot start scan: $can");
        return;
      }
    }

    // call startScan API
    final result = await WiFiScan.instance.startScan();

    if (mounted) kShowSnackBar(context, "startScan: $result");
    // reset access points.
    setState(() => accessPoints = <WiFiAccessPoint>[]);
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      // check if can-getScannedResults
      final can = await WiFiScan.instance.canGetScannedResults();
      // if can-not, then show error
      if (can != CanGetScannedResults.yes) {
        if (mounted) kShowSnackBar(context, "Cannot get scanned results: $can");
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }

  Future<void> _getScannedResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      // get scanned results
      final results = await WiFiScan.instance.getScannedResults();
      print('results $results');
      setState(() => accessPoints = results);
    }
  }

  // build toggle with label
  Widget _buildToggle({
    String? label,
    bool value = false,
    ValueChanged<bool>? onChanged,
    Color? activeColor,
  }) =>
      Row(
        children: [
          if (label != null) Text(label),
          Switch(value: value, onChanged: onChanged, activeColor: activeColor),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wifi'),
          actions: [
            _buildToggle(
                label: "Check can?",
                value: shouldCheckCan,
                onChanged: (v) => setState(() => shouldCheckCan = v),
                activeColor: Colors.purple)
          ],
        ),
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.perm_scan_wifi),
                      label: const Text('SCAN'),
                      onPressed: () async => await _startScan(context),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('GET'),
                      onPressed: () async => await _getScannedResults(context),
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          final res = await WiFiForIoTPlugin.isConnected();

                          setState(() {
                            isConnected = res;
                          });
                        },
                        icon: Icon(Icons.connect_without_contact),
                        label: const Text('Connected?')),
                    Text("$isConnected")
                  ],
                ),
                const Divider(),
                ElevatedButton(
                    onPressed: () async {
                      await WiFiForIoTPlugin.disconnect();
                    },
                    child: const Text('Disconnect')),
                Flexible(
                  child: Center(
                    child: accessPoints.isEmpty
                        ? const Text("NO SCANNED RESULTS")
                        : ListView.builder(
                            itemCount: accessPoints.length,
                            itemBuilder: (context, i) =>
                                _AccessPointTile(accessPoint: accessPoints[i]),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Show tile for AccessPoint.
///
/// Can see details when tapped.
class _AccessPointTile extends StatefulWidget {
  final WiFiAccessPoint accessPoint;

  const _AccessPointTile({Key? key, required this.accessPoint})
      : super(key: key);

  @override
  State<_AccessPointTile> createState() => _AccessPointTileState();
}

class _AccessPointTileState extends State<_AccessPointTile> {
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    super.dispose();
  }

  // build row that can display info, based on label: value pair.
  Widget _buildInfo(String label, dynamic value) => Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value.toString()))
          ],
        ),
      );

  Future<void> connectToWifi(String ssid, String bssid, String password) async {
    final res = await WiFiForIoTPlugin.connect(
      ssid,
      bssid: bssid,
      password: password,
      joinOnce: true,
      security: NetworkSecurity.WPA,
      withInternet: false,
    );
    print(res);

    if (res) await WiFiForIoTPlugin.forceWifiUsage(true);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.accessPoint.ssid.isNotEmpty
        ? widget.accessPoint.ssid
        : "**EMPTY**";

    final signalIcon = widget.accessPoint.level >= -80
        ? Icons.signal_wifi_4_bar
        : Icons.signal_wifi_0_bar;
    return ListTile(
        visualDensity: VisualDensity.compact,
        leading: Icon(signalIcon),
        title: Text(title),
        subtitle: Text(widget.accessPoint.capabilities),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(hintText: 'Password'),
                      obscureText: true,
                      controller: passwordController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextButton(
                        onPressed: () => connectToWifi(widget.accessPoint.ssid,
                            widget.accessPoint.bssid, passwordController.text),
                        child: const Text('Connect'))
                  ],
                ),
              ),
            ),
          );
        });
  }
}

/// Show snackbar.
void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
