import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/location_data.dart';
import '../providers/network_providers.dart';
import '../widgets/location_info_window.dart';
import '../widgets/search_options_bar.dart';

class NetworkScreen extends ConsumerStatefulWidget {
  const NetworkScreen({super.key});

  @override
  ConsumerState<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends ConsumerState<NetworkScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLocations();
    });
  }
  
  void _loadLocations() async {
    final locations = await ref.read(locationsProvider.future);
    
    setState(() {
      _markers = locations.map((location) {
        return Marker(
          markerId: MarkerId(location.id),
          position: LatLng(location.latitude, location.longitude),
          onTap: () => _onMarkerTapped(location),
          icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(location.type)),
        );
      }).toSet();
    });
  }
  
  void _onMarkerTapped(LocationData location) {
    ref.read(selectedLocationProvider.notifier).state = location;
    
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(location.latitude, location.longitude),
        15.0,
      ),
    );
  }
  
  double _getMarkerHue(String type) {
    switch (type.toLowerCase()) {
      case 'farm':
        return BitmapDescriptor.hueGreen;
      case 'gaushala':
        return BitmapDescriptor.hueOrange;
      case 'vet':
        return BitmapDescriptor.hueBlue;
      case 'dairy':
        return BitmapDescriptor.hueCyan;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  // Open directions in Google Maps
  void _openDirections(LocationData location) async {
    final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open directions')),
        );
      }
    }
  }
  
  // Open phone dialer for contact
  void _makePhoneCall(LocationData location) async {
    if (location.phone == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No phone number available')),
        );
      }
      return;
    }
    
    final url = Uri.parse('tel:${location.phone}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open phone dialer')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialCameraPositionAsync = ref.watch(initialCameraPositionProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);
    
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          initialCameraPositionAsync.when(
            data: (initialPosition) => GoogleMap(
              initialCameraPosition: initialPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onTap: (_) {
                // Clear selected location when map is tapped
                ref.read(selectedLocationProvider.notifier).state = null;
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(
              child: Text('Error loading map. Please try again later.'),
            ),
          ),
          
          // Search bar at the top
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SearchOptionsBar(),
          ),
          
          // Selected location info window at the bottom
          if (selectedLocation != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: LocationInfoWindow(
                location: selectedLocation,
                onDirectionsTap: () => _openDirections(selectedLocation),
                onContactTap: () => _makePhoneCall(selectedLocation),
                onCloseTap: () {
                  ref.read(selectedLocationProvider.notifier).state = null;
                },
              ),
            ),
        ],
      ),
      
      // Location error message
      floatingActionButton: ref.watch(currentPositionProvider).maybeWhen(
        error: (error, _) => FloatingActionButton.extended(
          onPressed: () {
            ref.invalidate(currentPositionProvider);
          },
          label: const Text('Enable Location'),
          icon: const Icon(Icons.location_on),
        ),
        orElse: () => null,
      ),
    );
  }
}