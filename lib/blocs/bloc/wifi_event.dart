part of 'wifi_bloc.dart';

@immutable
sealed class WifiEvent {}

class ScanWifiNetworks implements WifiEvent {
  const ScanWifiNetworks();
}

class GetWifiNetworks implements WifiEvent {
  const GetWifiNetworks();
}

class ConnetToWifiNetwork implements WifiEvent {
  const ConnetToWifiNetwork({required this.connectionInfo});

  final ConnectionInfo connectionInfo;
}

class DisconnectFromWifiNetwork implements WifiEvent {
  const DisconnectFromWifiNetwork();
}
