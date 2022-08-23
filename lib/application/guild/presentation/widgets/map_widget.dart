import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:mapir_raster/mapir_raster.dart';

class MapWidget extends StatelessWidget {
  final lat_lng.LatLng defaultPinLocation;
  final void Function(lat_lng.LatLng location) onChangePinLocation;

  MapWidget({required this.defaultPinLocation, required this.onChangePinLocation, Key? key}) : super(key: key);

  final MapController controller = MapController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          child: SizedBox(
            height: 300,
            width: 300,
            child: Stack(
              children: [
                MapirMap(
                  apiKey: apiMapKey,
                  options: MapOptions(center: defaultPinLocation, zoom: 16.0),
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
