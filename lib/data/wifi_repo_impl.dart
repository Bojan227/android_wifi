import 'package:wifi_networks/data/models/connection_info.dart';
import 'package:wifi_networks/data/wifi_provider.dart';
import 'package:wifi_networks/data/wifi_repository.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiRepository implements IWifiRepository {
  const WifiRepository({required this.provider});

  final WifiProvider provider;

  @override
  Future<List<WiFiAccessPoint>> getWifiNetworks() async {
    return await provider.getWifiNetworks();
  }

  @override
  Future<bool> scanWifiNetworks() async {
    return await provider.scanWifiNetworks();
  }

  @override
  Future<void> connectToWifiNetwork(ConnectionInfo connectionInfo) async {
    return await provider.connectToWifiNetwork(connectionInfo);
  }

  @override
  Future<void> disconnectFromWifiNetwork(ConnectionInfo connectionInfo) async {
    return await provider.disconnectFromWifiNetwork(connectionInfo);
  }
}
