import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../models/property_model.dart';
import '../pages/property_detail_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  Property? _selectedProperty;
  
  // Default location (Mumbai)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(19.0760, 72.8777),
    zoom: 11,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Map'),
        actions: [
          IconButton(
            onPressed: _showMapControls,
            icon: const Icon(Icons.layers),
          ),
        ],
      ),
      body: Consumer<PropertyProvider>(
        builder: (context, propertyProvider, child) {
          final properties = propertyProvider.filteredProperties;
          
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _initialPosition,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  _createMarkers(properties);
                },
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                onTap: (_) {
                  setState(() {
                    _selectedProperty = null;
                  });
                },
              ),
              
              // Search and filter bar
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${properties.length} properties found',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _fitAllMarkers(properties);
                          },
                          icon: const Icon(Icons.my_location),
                          tooltip: 'Show all properties',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Property details card
              if (_selectedProperty != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _buildPropertyCard(_selectedProperty!),
                ),
              
              // Map type toggle
              Positioned(
                top: 100,
                right: 16,
                child: Column(
                  children: [
                    FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        _changeMapType(MapType.normal);
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.map, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        _changeMapType(MapType.satellite);
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.satellite, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _createMarkers(List<Property> properties) {
    final markers = <Marker>{};
    
    for (final property in properties) {
      final marker = Marker(
        markerId: MarkerId(property.id),
        position: LatLng(property.latitude, property.longitude),
        onTap: () {
          setState(() {
            _selectedProperty = property;
          });
          _animateToProperty(property);
        },
        icon: _getMarkerIcon(property.type),
        infoWindow: InfoWindow(
          title: property.title,
          snippet: _formatPrice(property.price, property.type),
        ),
      );
      markers.add(marker);
    }
    
    setState(() {
      _markers = markers;
    });
  }

  BitmapDescriptor _getMarkerIcon(String type) {
    switch (type.toLowerCase()) {
      case 'rent':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'sale':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'pg':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  void _animateToProperty(Property property) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(property.latitude, property.longitude),
          zoom: 15,
        ),
      ),
    );
  }

  void _fitAllMarkers(List<Property> properties) {
    if (properties.isEmpty) return;
    
    double minLat = properties.first.latitude;
    double maxLat = properties.first.latitude;
    double minLng = properties.first.longitude;
    double maxLng = properties.first.longitude;
    
    for (final property in properties) {
      minLat = property.latitude < minLat ? property.latitude : minLat;
      maxLat = property.latitude > maxLat ? property.latitude : maxLat;
      minLng = property.longitude < minLng ? property.longitude : minLng;
      maxLng = property.longitude > maxLng ? property.longitude : maxLng;
    }
    
    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0, // padding
      ),
    );
  }

  void _changeMapType(MapType mapType) {
    // This would be implemented if we had access to change map type
    // For now, it's just a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Map type: ${mapType.name}')),
    );
  }

  Widget _buildPropertyCard(Property property) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        property.address,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatPrice(property.price, property.type),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildDetailChip(Icons.bed, '${property.bedrooms}'),
                const SizedBox(width: 8),
                _buildDetailChip(Icons.bathtub, '${property.bathrooms}'),
                const SizedBox(width: 8),
                _buildDetailChip(Icons.square_foot, '${property.area.toInt()}'),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailPage(property: property),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price, String type) {
    if (price >= 10000000) {
      return '₹${(price / 10000000).toStringAsFixed(1)}Cr';
    } else if (price >= 100000) {
      return '₹${(price / 100000).toStringAsFixed(1)}L';
    } else if (price >= 1000) {
      return '₹${(price / 1000).toStringAsFixed(0)}K';
    } else {
      return '₹${price.toStringAsFixed(0)}';
    }
  }

  void _showMapControls() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Map Controls',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.red),
              title: const Text('For Sale'),
              subtitle: const Text('Properties available for purchase'),
              trailing: Icon(Icons.circle, color: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen).toString().contains('green') ? Colors.green : Colors.red),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.blue),
              title: const Text('For Rent'),
              subtitle: const Text('Properties available for rent'),
              trailing: Icon(Icons.circle, color: Colors.blue),
            ),
            ListTile(
              leading: const Icon(Icons.bed, color: Colors.orange),
              title: const Text('PG Accommodation'),
              subtitle: const Text('Paying guest accommodations'),
              trailing: Icon(Icons.circle, color: Colors.orange),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tap on any marker to view property details',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}