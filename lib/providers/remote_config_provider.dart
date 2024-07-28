import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigProvider with ChangeNotifier {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigProvider() : _remoteConfig = FirebaseRemoteConfig.instance {
    fetchRemoteConfig();
  }

  Future<void> fetchRemoteConfig() async {
    print("Fetching remote config");
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 0),
        ),
      );

      remoteConfig.onConfigUpdated.listen((RemoteConfigUpdate event) async {
        await remoteConfig.activate();
        notifyListeners();
      });

      await remoteConfig.fetchAndActivate();
      print("Remote config fetched and activated");
      notifyListeners();
    } catch (e) {
      print('Failed to fetch remote config: $e');
    }
  }

  bool get enableDiscount => _remoteConfig.getBool("enableDiscount");
}
