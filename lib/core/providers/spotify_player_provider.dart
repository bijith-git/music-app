import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/client/api_client.dart';
import 'package:spotify_clone/core/constants/api_path.dart';
import 'package:spotify_clone/model/connected_device_model.dart';

class SpotfiyPlayerProvider extends ChangeNotifier {
  List<Device> devices = [];
  static final dio = createDio();
  final inspector = DioInspector(dio);
  SpotfiyPlayerProvider() {
    getConnectDevices();
  }

  getConnectDevices() async {
    final response = await inspector.send<dynamic>(
      RequestOptions(
        method: 'GET',
        path: ApiConfig.baseUrl + ApiEndPoint.getDevices,
      ),
    );
    if (response.data != null) {
      devices.clear();
      response.data['devices']
          .map((e) => devices.add(Device.fromJson(e)))
          .toList();
      notifyListeners();
    }
  }

  changeDevices(String deviceId) async {
    final response = await inspector.send<dynamic>(
      RequestOptions(
          method: 'PUT',
          path: ApiConfig.baseUrl + ApiEndPoint.transferPlay,
          data: {
            "device_ids": [deviceId]
          }),
    );
    if (response.data != null) {
      getConnectDevices();
    }
  }
}
