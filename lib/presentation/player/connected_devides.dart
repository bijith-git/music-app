import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/core/providers/spotify_player_provider.dart';

class ConnectedDevicesWidget extends StatefulWidget {
  const ConnectedDevicesWidget({super.key});

  @override
  State<ConnectedDevicesWidget> createState() => _ConnectedDevicesWidgetState();
}

class _ConnectedDevicesWidgetState extends State<ConnectedDevicesWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SpotfiyPlayerProvider(),
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close)),
                )
              ],
            ),
            body: Consumer<SpotfiyPlayerProvider>(
              builder: (context, state, _) {
                return ListView.builder(
                    itemCount: state.devices.length,
                    itemBuilder: (_, i) {
                      var device = state.devices[i];

                      return ListTile(
                        onTap: () {
                          state.changeDevices(device.id);
                        },
                        leading: Icon(device.type == "Smartphone"
                            ? Icons.smartphone
                            : Icons.computer),
                        title: Text(
                          device.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("${device.volumePercent}% volume"),
                        trailing: device.isActive
                            ? Text(
                                "Active",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                              )
                            : const SizedBox(),
                      );
                    });
              },
            ),
          );
        });
  }
}
