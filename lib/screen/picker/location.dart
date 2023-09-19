import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/routes/page_manager.dart';
import 'package:puth_story/widgets/platform_scaffold.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationPage extends StatefulWidget {
  final Function() onSend;

  const LocationPage({super.key, required this.onSend});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final defaultLocation = const LatLng(-6.1754083, 106.8204524);
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  void initState() {
    final marker = Marker(
        markerId: const MarkerId("puth-story"),
        position: defaultLocation,
        onTap: () {
          mapController
              .animateCamera(CameraUpdate.newLatLngZoom(defaultLocation, 18));
        });
    markers.add(marker);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        title: "Pick Location",
        child: Center(
          child: Stack(
            children: [
              GoogleMap(
                markers: markers,
                mapType: MapType.normal,
                initialCameraPosition:
                    CameraPosition(zoom: 16, target: defaultLocation),
                onMapCreated: (controller) {
                  setState(() {
                    getLocationInfo(defaultLocation);
                    mapController = controller;
                  });
                },
                onLongPress: (LatLng latLng) {
                  onMapLongPress(latLng);
                },
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
              if(placemark != null) Positioned(
                top: 16,
                right: 16,
                child: ElevatedButton(
                  child: const Text("Save"),
                  onPressed: (){
                    onSendLocation();
                  },
                ),
              ),
              Positioned(
                  bottom: 16,
                  right: 16,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        onPressed: () {
                          mapController.animateCamera(CameraUpdate.zoomIn());
                        },
                        heroTag: "zoom-in",
                        child: const Icon(Icons.add),
                      ),
                      FloatingActionButton.small(
                        onPressed: () {
                          mapController.animateCamera(CameraUpdate.zoomOut());
                        },
                        heroTag: "zoom-out",
                        child: const Icon(Icons.remove),
                      ),
                      FloatingActionButton.small(
                        onPressed: () {
                          getMylocation();
                        },
                        heroTag: "zoom-out",
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
              ),
              if(placemark == null) const SizedBox()
              else Positioned(
                bottom: 16,
                  right: 16,
                  left: 16,
                  child: PlacemarkWidget(
                    placemark: placemark!,
                  ),
              ),
            ],
          ),
        ));
  }

  void getMylocation() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionStatus;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      print("Location is not enabled");
      return;
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();

      if (permissionStatus != PermissionStatus.granted) {
        print("Location Permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    getLocationInfo(latLng);
  }

  void updateMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("location"),
      position: latLng,
      infoWindow: InfoWindow(title: street, snippet: address),
    );

    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  void onMapLongPress(LatLng latLng) {
    getLocationInfo(latLng);
  }

  void getLocationInfo(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    updateMarker(latLng, street ?? "Unknown Place", address);

    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  void onSendLocation(){
    if(markers.length > 1){
      context.read<PageManager>().returnLocationData(markers.elementAt(0).position);
      widget.onSend();
    }
  }
}

class PlacemarkWidget extends StatelessWidget {
  const PlacemarkWidget({super.key, required this.placemark});

  final geo.Placemark placemark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 20,
              offset: Offset.zero,
              color: Colors.grey.withOpacity(0.5),
            )
          ]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  placemark.street!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
