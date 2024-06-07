import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:map/api/api_client.dart';
import 'package:map/model/address_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TSearchController extends GetxController {
  static TSearchController get instance => Get.find();
  ApiClient apiClient = Get.put(ApiClient());
  var searchList = [].obs;
  RxString query = ''.obs;
  bool _isLoading = false;
  Timer? _debounce;
  final String apiKey = dotenv.env['API_KEY']!;

  bool get loading => _isLoading;

  void updateQuery(newQuery) {
    query.value = newQuery;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      onSearch();
    });
  }

  Future<void> onSearch() async {
    _isLoading = true;
    update();
    final headers = {
      'Content-Type': 'application/json',
    };
    final queryParams = {'q': query.value, 'limit': '10', 'apiKey': apiKey};
    var response =
        await apiClient.getData('geocode', headers, query: queryParams);

    if (response.statusCode == 200) {
      searchList.value = (response.body['items'] as List)
          .map((json) => Address.fromJson(json))
          .toList();
    } else {
      print(response.body);
    }
    _isLoading = false;
    update();
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    return await Geolocator.getCurrentPosition();
  }



  Future<void> navigateToAddress(int index) async {
    try {
      Position position = await _getCurrentLocation();
      Address address = searchList[index];

      final Uri googleMapsUrl = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination='
          '${address.position.lat},${address.position.lng} &origin=${position.latitude},${position.longitude}');
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else {
        throw 'Could not launch $googleMapsUrl';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }
}
