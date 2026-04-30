import 'dart:io';

import 'package:image/image.dart' as image;

Future<void> main() async {
  final source = File('lib/assets/launcher/app_icon.png');
  final target = File('lib/assets/launcher/app_icon_rgba.png');

  if (!await source.exists()) {
    stderr.writeln('Missing source icon: ${source.path}');
    exitCode = 1;
    return;
  }

  final decoded = image.decodeImage(await source.readAsBytes());
  if (decoded == null) {
    stderr.writeln('Unable to decode icon: ${source.path}');
    exitCode = 1;
    return;
  }

  await target.writeAsBytes(image.encodePng(decoded));
  stdout.writeln('Wrote ${target.path}');
}
