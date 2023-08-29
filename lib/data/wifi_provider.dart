import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_networks/data/models/connection_info.dart';
import 'package:wifi_scan/wifi_scan.dart';

abstract class IWifiProvider {
  Future<bool> scanWifiNetworks();
  Future<List<WiFiAccessPoint>> getWifiNetworks();
  Future<void> connectToWifiNetwork(ConnectionInfo connectionInfo);
  Future<void> disconnectFromWifiNetwork(ConnectionInfo connectionInfo);
}

class WifiProvider implements IWifiProvider {
  @override
  Future<List<WiFiAccessPoint>> getWifiNetworks() async {
    final canGetResults = await WiFiScan.instance.canGetScannedResults();

    if (canGetResults != CanGetScannedResults.yes) {
      throw Error();
    }

    return await WiFiScan.instance.getScannedResults();
  }

  @override
  Future<bool> scanWifiNetworks() async {
    final canScan = await WiFiScan.instance.canStartScan();

    if (canScan == CanStartScan.noLocationServiceDisabled) {
      throw ('Please enable your location');
    }

    if (canScan != CanStartScan.yes) {
      throw ('Unable to scan');
    }

    return await WiFiScan.instance.startScan();
  }

  @override
  Future<void> connectToWifiNetwork(ConnectionInfo connectionInfo) async {
    final response = await WiFiForIoTPlugin.connect(
      connectionInfo.ssid,
      bssid: connectionInfo.bssid,
      password: connectionInfo.password,
      joinOnce: true,
      security: NetworkSecurity.NONE,
      withInternet: false,
    );
    if (!response) throw ('Failed to connect');

    if (response) await WiFiForIoTPlugin.forceWifiUsage(true);
  }

  @override
  Future<void> disconnectFromWifiNetwork(ConnectionInfo connectionInfo) async {
    await WiFiForIoTPlugin.disconnect();
    await WiFiForIoTPlugin.removeWifiNetwork(connectionInfo.ssid);
  }
}
