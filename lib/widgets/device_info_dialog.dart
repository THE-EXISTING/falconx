import 'dart:io';
import 'package:falconx/lib.dart';

class DeviceInfoDialog extends StatelessWidget {
  const DeviceInfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      title: Container(
        padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
        child: const Text(
          'Device Info',
          // style: TextStyle(color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.all(0),
      content: _getContent(),
    );
  }

  Widget _getContent() {
    if (Platform.isAndroid) {
      return _androidContent();
    }
    if (Platform.isIOS) {
      return _iOSContent();
    }
    return const Text("You're not on Android neither iOS");
  }

  Widget _iOSContent() {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return FutureBuilder<IosDeviceInfo>(
      future: deviceInfo.iosInfo,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final device = snapshot.data;
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTile(
                'Physical device: ',
                device?.isPhysicalDevice.toString(),
              ),
              _buildTile('Device: ', device?.name),
              _buildTile('Model: ', device?.model),
              _buildTile('System name: ', device?.systemName),
              _buildTile('System version: ', device?.systemVersion),
            ],
          ),
        );
      },
    );
  }

  Widget _androidContent() {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return FutureBuilder<AndroidDeviceInfo>(
      future: deviceInfo.androidInfo,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        final device = snapshot.data;
        return FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              final package = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildTile('App name: ', package?.appName),
                    _buildTile('Version: ',
                        '${package?.version} (${package?.buildNumber})'),
                    _buildTile('Package name: ', package?.packageName),
                    Space.height24,
                    _buildTile('Android version: ', device?.version.release),
                    _buildTile(
                        'Android SDK: ', device?.version.sdkInt.toString()),
                    _buildTile(
                      'Physical device: ',
                      device?.isPhysicalDevice.toString(),
                    ),
                    _buildTile('Manufacturer: ', device?.manufacturer),
                    _buildTile('Model: ', device?.model),
                    _buildTile('Device: ', device?.device),
                    _buildTile('Hardware: ', device?.hardware),
                  ],
                ),
              );
            });
      },
    );
  }

  Widget _buildTile(String key, String? value) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value ?? ''))
        ],
      ),
    );
  }

}
