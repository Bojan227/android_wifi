// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'wifi_bloc.dart';

enum Status { initial, loading, success, failure }

@immutable
class WifiState extends Equatable {
  final List<WiFiAccessPoint> accessPoints;
  final Status status;
  final Status connectionStatus;
  final ConnectionInfo? currentWifiAccessPoint;
  final String? errorMessage;

  const WifiState({
    required this.accessPoints,
    required this.status,
    required this.connectionStatus,
    this.errorMessage,
    this.currentWifiAccessPoint,
  });

  @override
  List<Object?> get props => [
        accessPoints,
        status,
        currentWifiAccessPoint,
        errorMessage,
        connectionStatus
      ];

  WifiState copyWith(
      {List<WiFiAccessPoint>? accessPoints,
      Status? status,
      Status? connectionStatus,
      ConnectionInfo? currentWifiAccessPoint,
      String? errorMessage}) {
    return WifiState(
      accessPoints: accessPoints ?? this.accessPoints,
      status: status ?? this.status,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      currentWifiAccessPoint:
          currentWifiAccessPoint ?? this.currentWifiAccessPoint,
    );
  }
}
