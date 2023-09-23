import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/model/api/detail_story.dart';
import 'package:puth_story/provider/story_provider.dart';
import 'package:puth_story/utils/result_state.dart';
import 'package:puth_story/widgets/platform_scaffold.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:puth_story/widgets/v_margin.dart';

class DetailStoryPage extends StatefulWidget {
  final String storyId;

  const DetailStoryPage({super.key, required this.storyId});

  @override
  State<DetailStoryPage> createState() => _DetailStoryPageState();
}

class _DetailStoryPageState extends State<DetailStoryPage> {

  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  void initState() {
    Future.microtask(() => context.read<StoryProvider>().fetchDetail(widget.storyId));

    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PlatformScaffold(
      title: "Puth Story",
      child: SingleChildScrollView(
        child: _storyListener(context)
      ),
    );
  }

  Widget _storyListener(BuildContext context) {
    return Consumer<StoryProvider>(builder: (context, provider, _) {
      switch (provider.getByIdState) {
        case ResultState.hasData:
          return _storyDetail(context, provider.data!);
        case ResultState.error:
          return const Center(
            child: Text("Failed to load story"),
          );
        default:
          return const Center(
            child: CircularProgressIndicator(),
          );
      }
    });
  }

  Widget _storyDetail(BuildContext context, Story story) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: story.id,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.network(story.photoUrl),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(story.name, style: Theme.of(context).textTheme.labelLarge),
              Text(story.description,
                  style: Theme.of(context).textTheme.labelMedium),
              const VMargin(
                height: 20,
              ),
              if(story.lat != null && story.lon != null) SizedBox(
                height: 300,
                child: _storyLocation(context, story),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _storyLocation(BuildContext context, Story story){
    const defaultLocation = LatLng(-6.1754083, 106.8204524);

    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: defaultLocation,
        zoom: 16,
      ),
      onMapCreated: (controller) {
        setState(() {
          mapController = controller;
          getLocationInfo(LatLng(story.lat!, story.lon!));
        });
      },
      markers: markers,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
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

  void updateMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("story-location"),
      position: latLng,
      infoWindow: InfoWindow(title: street, snippet: address),
    );

    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}
