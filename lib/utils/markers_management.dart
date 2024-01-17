import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersManagement {
  Set<Marker> _markers = {};

  Set<Marker> get markers => _markers;

  // Constructor
  MarkersManagement({Set<Marker>? initialMarkers}) {
    if (initialMarkers != null) {
      _markers = initialMarkers;
    }
  }

  // Update the color of a specific marker
  void updateMarkerColor(String markerId, Color color) {
    final marker = _markers.firstWhere(
      (m) => m.markerId.value == markerId,
      orElse: () => const Marker(markerId: MarkerId('')),
    );

    if (marker != const Marker(markerId: MarkerId(''))) {
      final updatedMarker = marker.copyWith(
        iconParam: BitmapDescriptor.defaultMarkerWithHue(
          _getHueFromColor(color),
        ),
      );

      _markers.remove(marker);
      _markers.add(updatedMarker);
    }
  }

  // Helper method to convert a Color to a BitmapDescriptor hue
  double _getHueFromColor(Color color) {
    // This is a simplified way to convert any color to a hue that
    // can be used by the BitmapDescriptor. You might want to expand
    // this method to handle more colors accurately.
    return color == Colors.red
        ? BitmapDescriptor.hueRed
        : color == Colors.yellow
            ? BitmapDescriptor.hueYellow
            : color == Colors.blue
                ? BitmapDescriptor.hueBlue
                : color == Colors.green
                    ? BitmapDescriptor.hueGreen
                    : color == Colors.orange
                        ? BitmapDescriptor.hueOrange
                        : color == Colors.purple
                            ? BitmapDescriptor.hueViolet
                            : BitmapDescriptor
                                .hueRed; // Default to red if color not matched
  }

  // Update the markers set with new markers
  void updateMarkers(Set<Marker> newMarkers) {
    _markers = newMarkers;
  }

  // Add a single marker to the set
  void addMarker(Marker marker) {
    _markers.add(marker);
  }

  // Remove a single marker from the set
  void removeMarker(Marker marker) {
    _markers.remove(marker);
  }

  // Clear all markers from the set
  void clearMarkers() {
    _markers.clear();
  }
}
