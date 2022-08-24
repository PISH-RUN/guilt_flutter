import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:mapir_raster/mapir_raster.dart';

class MapWidget extends StatelessWidget {
  final lat_lng.LatLng? defaultPinLocation;
  final void Function(lat_lng.LatLng location) onChangePinLocation;

  MapWidget({required this.defaultPinLocation, required this.onChangePinLocation, Key? key}) : super(key: key);

  final MapController controller = MapController();

  late lat_lng.LatLng location;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<lat_lng.LatLng>(
        future: getUserLocation(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
              height: 345,
              width: 300,
              child: LoadingWidget(),
            );
          }
          if (snapshot.hasData && defaultPinLocation == null) {
            location = snapshot.data!;
          }
          if (defaultPinLocation != null) {
            location = defaultPinLocation!;
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Stack(
                    children: [
                      MapirMap(
                        apiKey: apiMapKey,
                        options: MapOptions(center: location, zoom: 16.0),
                        layers: const [],
                        mapController: controller,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.location_on, color: Colors.red, size: 40.0),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  onChangePinLocation(controller.center);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 45.0,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
                  ),
                  child: Text("ثبت", style: defaultTextStyle(context, headline: 4).c(Colors.white)),
                ),
              ),
            ],
          );
        });
  }

  Future<lat_lng.LatLng> getUserLocation() async {
    lat_lng.LatLng location = lat_lng.LatLng(43.5435, 12.34234);
    if (defaultPinLocation != null) {
      return defaultPinLocation!;
    }
    await GetIt.instance<RemoteDataSource>().getFromServer(
      url: 'http://ip-api.com/json',
      params: {},
      mapSuccess: (data) => location = lat_lng.LatLng(data['lat'], data['lon']),
    );
    return location;
  }
}

class MapScreenShotWidget extends StatelessWidget {
  final lat_lng.LatLng pinLocation;

  MapScreenShotWidget({required this.pinLocation, Key? key}) : super(key: key);

  final MapController controller = MapController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xffEEEBE7).withOpacity(1.0),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(3, 3),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: MapirMap(
          key: UniqueKey(),
          apiKey: apiMapKey,
          options: MapOptions(center: pinLocation, zoom: 16.0),
          layers: [
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 40.0,
                  height: 40.0,
                  point: pinLocation,
                  builder: (ctx) => const Icon(Icons.location_on, size: 40.0, color: Colors.red),
                ),
              ],
            ),
          ],
          mapController: controller,
        ),
      ),
    );
  }
}
//  for generate files: flutter pub run build_runner build

//      flutter run -d chrome --web-renderer html <==============> flutter run -d chrome --web-renderer canvaskit

//  to generate release app
//     1.increase version number
//     2.flutter build web --web-renderer html --release  <==============> flutter build web --web-renderer canvaskit
//     3.flutter build apk <==============> flutter build appbundle