import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/enums/repeat_mode_enum.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class RepeatButton extends StatefulWidget {
  final RepeatMode repeatMode;
  final double width;
  final Color iconColor;
  final EdgeInsetsGeometry padding;
  final Decoration decoration;
  const RepeatButton(
      {Key? key,
      required this.repeatMode,
      required this.width,
      this.padding = EdgeInsets.zero,
      this.decoration = const BoxDecoration(),
      this.iconColor = Colors.white})
      : super(key: key);
  @override
  State<RepeatButton> createState() => _RepeatButtonState();
}

class _RepeatButtonState extends State<RepeatButton> {
  RepeatMode repeatMode = RepeatMode.off;

  void _toggleRepeatMode() {
    setState(() {
      switch (widget.repeatMode) {
        case RepeatMode.off:
          repeatMode = RepeatMode.track;
          break;
        case RepeatMode.track:
          repeatMode = RepeatMode.context;
          break;
        case RepeatMode.context:
          repeatMode = RepeatMode.off;
          break;
      }
      setRepeatMode(repeatMode);
    });
  }

  Future<void> setRepeatMode(RepeatMode repeatMode) async {
    try {
      await SpotifySdk.setRepeatMode(
        repeatMode: repeatMode,
      );
    } on PlatformException catch (e) {
    } on MissingPluginException {}
  }

  IconData _getIcon() {
    switch (widget.repeatMode) {
      case RepeatMode.off:
        return Icons.repeat;
      case RepeatMode.track:
        return Icons.repeat_on;
      case RepeatMode.context:
        return Icons.repeat_one;
      default:
        return Icons.repeat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: widget.padding,
      decoration: widget.decoration,
      child: TextButton(
        onPressed: _toggleRepeatMode,
        child: Icon(
          _getIcon(),
          color: widget.iconColor,
        ),
      ),
    );
  }
}
