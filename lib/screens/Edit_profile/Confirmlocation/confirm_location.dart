import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator package
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import Google Maps package

class ConfirmLocation extends StatefulWidget {
  const ConfirmLocation({super.key});

  @override
  State<ConfirmLocation> createState() => _ConfirmLocationState();
}

class _ConfirmLocationState extends State<ConfirmLocation> {
  String selectedAddress = "";
  String currentAddress = "Fetching current location...";
  LatLng? currentLatLng;
  GoogleMapController? mapController;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        currentAddress = "Location services are disabled.";
      });
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          currentAddress = "Location permissions are denied.";
        });
        return;
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
      currentAddress = "Lat: ${position.latitude}, Long: ${position.longitude}";
    });

    // Move the map camera to the current position
    mapController?.animateCamera(
      CameraUpdate.newLatLng(currentLatLng!),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.NSwhite,
      appBar: AppBar(
        backgroundColor: TColors.NSwhite,
        title: Text(
          'Confirm Location',
          style: GoogleFonts.aBeeZee(fontSize: 18.5),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: TColors.iconlink,
            size: 21,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: currentLatLng == null
          ? Center(
              child: Text(
                currentAddress,
                style: GoogleFonts.aBeeZee(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentLatLng!,
                      zoom: 15,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("currentLocation"),
                        position: currentLatLng!,
                      ),
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    currentAddress,
                    style: GoogleFonts.aBeeZee(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedAddress = currentAddress;
                    });
                    Navigator.pop(context, selectedAddress);
                  },
                  child: Text(
                    'Confirm Location',
                    style: GoogleFonts.aBeeZee(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
    );
  }
}
