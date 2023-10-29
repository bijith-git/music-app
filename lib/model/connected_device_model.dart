// To parse this JSON data, do
//
//     final connectedDevicesModel = connectedDevicesModelFromJson(jsonString);

import 'dart:convert';

ConnectedDevicesModel connectedDevicesModelFromJson(String str) =>
    ConnectedDevicesModel.fromJson(json.decode(str));

String connectedDevicesModelToJson(ConnectedDevicesModel data) =>
    json.encode(data.toJson());

class ConnectedDevicesModel {
  List<Device> devices;

  ConnectedDevicesModel({
    required this.devices,
  });

  factory ConnectedDevicesModel.fromJson(Map<String, dynamic> json) =>
      ConnectedDevicesModel(
        devices:
            List<Device>.from(json["devices"].map((x) => Device.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "devices": List<dynamic>.from(devices.map((x) => x.toJson())),
      };
}

class Device {
  String id;
  bool isActive;
  bool isPrivateSession;
  bool isRestricted;
  String name;
  bool supportsVolume;
  String type;
  int volumePercent;

  Device({
    required this.id,
    required this.isActive,
    required this.isPrivateSession,
    required this.isRestricted,
    required this.name,
    required this.supportsVolume,
    required this.type,
    required this.volumePercent,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["id"],
        isActive: json["is_active"],
        isPrivateSession: json["is_private_session"],
        isRestricted: json["is_restricted"],
        name: json["name"],
        supportsVolume: json["supports_volume"],
        type: json["type"],
        volumePercent: json["volume_percent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_active": isActive,
        "is_private_session": isPrivateSession,
        "is_restricted": isRestricted,
        "name": name,
        "supports_volume": supportsVolume,
        "type": type,
        "volume_percent": volumePercent,
      };
}
