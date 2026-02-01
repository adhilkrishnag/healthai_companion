import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Network information service for checking connectivity
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

/// Implementation using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    // Handle both single result and list (API changed in newer versions)
    if (results is List) {
      return !(results as List).contains(ConnectivityResult.none);
    }
    return results != ConnectivityResult.none;
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      // Handle both single result and list
      if (results is List) {
        return !(results as List).contains(ConnectivityResult.none);
      }
      return results != ConnectivityResult.none;
    });
  }
}

/// Provider for network info
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});

/// Stream provider for connectivity status
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  return networkInfo.onConnectivityChanged;
});
