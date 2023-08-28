import 'package:wifi_networks/data/models/connection_info.dart';
import 'package:wifi_scan/wifi_scan.dart';

abstract class IWifiRepository {
  Future<bool> scanWifiNetworks();
  Future<List<WiFiAccessPoint>> getWifiNetworks();
  Future<void> connectToWifiNetwork(ConnectionInfo connectionInfo);
  Future<void> disconnectFromWifiNetwork(ConnectionInfo connectionInfo);
}
