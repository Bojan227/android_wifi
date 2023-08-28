import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wifi_networks/data/models/connection_info.dart';
import 'package:wifi_networks/data/wifi_repo_impl.dart';
import 'package:wifi_scan/wifi_scan.dart';

part 'wifi_event.dart';
part 'wifi_state.dart';

class WifiBloc extends Bloc<WifiEvent, WifiState> {
  final WifiRepository wifiRepository;

  WifiBloc({required this.wifiRepository})
      : super(const WifiState(
          accessPoints: [],
          status: Status.initial,
          connectionStatus: Status.initial,
        )) {
    on<ScanWifiNetworks>(_onScanWifiNetworks);
    on<GetWifiNetworks>(_onGetWifiNetworks);
    on<ConnetToWifiNetwork>(_onConnect);
    on<DisconnectFromWifiNetwork>(_onDisconnect);
  }

  Future<void> _onScanWifiNetworks(ScanWifiNetworks event, Emitter emit) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final result = await wifiRepository.scanWifiNetworks();

      if (result) {
        await _onGetWifiNetworks(const GetWifiNetworks(), emit);
      }
    } catch (error) {
      emit(state.copyWith(
          status: Status.failure, errorMessage: error.toString()));
    }
  }

  Future<void> _onGetWifiNetworks(GetWifiNetworks event, Emitter emit) async {
    try {
      final wifiAccessPoints = await wifiRepository.getWifiNetworks();

      emit(state.copyWith(
          accessPoints: wifiAccessPoints, status: Status.success));
    } catch (error) {
      emit(state.copyWith(
          status: Status.failure, errorMessage: error.toString()));
    }
  }

  Future<void> _onConnect(ConnetToWifiNetwork event, Emitter emit) async {
    emit(state.copyWith(connectionStatus: Status.loading));

    try {
      await wifiRepository.connectToWifiNetwork(event.connectionInfo);

      emit(state.copyWith(
          currentWifiAccessPoint: event.connectionInfo,
          connectionStatus: Status.success));
    } catch (error) {
      emit(state.copyWith(connectionStatus: Status.failure));
    }
  }

  Future<void> _onDisconnect(
      DisconnectFromWifiNetwork event, Emitter emit) async {
    emit(state.copyWith(connectionStatus: Status.loading));

    try {
      await wifiRepository
          .disconnectFromWifiNetwork(state.currentWifiAccessPoint!);

      emit(state.copyWith(
          currentWifiAccessPoint:
              ConnectionInfo(ssid: '', bssid: '', password: ''),
          connectionStatus: Status.initial));
    } catch (error) {
      emit(state.copyWith(connectionStatus: Status.failure));
    }
  }
}
