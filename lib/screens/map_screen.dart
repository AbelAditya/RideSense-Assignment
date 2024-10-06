import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.lat, required this.long});

  final double lat;
  final double long;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      );

  TileLayer get satelliteTileLayer => TileLayer(
        urlTemplate: "https://tile.opentopomap.org/{z}/{x}/{y}.png",
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      );

  // TileLayer get TerrainTileLayer => TileLayer(
  //       urlTemplate: "https://{s}.tile.stamen.com/terrain/{z}/{x}/{y}.png",
  //       userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  //       subdomains: ['a','b','c'],
  //     );

  String _currMapType = "OSM";

  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeInOutBack;
  final double _fabHeight = 56.0;
  LatLng? _userLocation;
  late List<Marker> markers;

  Future<bool> _checkLocationPermission() async {
    if (await Permission.locationWhenInUse.isGranted) {
      return true;
    } else {
      final status = await Permission.locationWhenInUse.request();
      return status.isGranted;
    }
  }

  Future<void> _getUserLocation() async {
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) return;

    Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high));

    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      if (_userLocation != null) {
        markers.add(
          Marker(
            point: _userLocation!,
            height: 60,
            width: 60,
            alignment: Alignment.topCenter,
            child: const Icon(
              Icons.location_pin,
              color: Colors.blue,
              size: 60,
            ),
          ),
        );
      }
    });
  }

  @override
  initState() {
    markers = [
      Marker(
        point: LatLng(widget.lat, widget.long),
        height: 60,
        width: 60,
        alignment: Alignment.topCenter,
        child: const Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 60,
        ),
      ),
    ];
    _getUserLocation();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  // Widget terrain() {
  //   return FloatingActionButton(
  //     onPressed: ()=> setState(() {
  //       _currMapType="Terrain";
  //     }),
  //     tooltip: 'Terrain',
  //     child: const Icon(Icons.terrain),
  //   );
  // }

  Widget satellite() {
    return FloatingActionButton(
      heroTag: "satellite",
      onPressed: () {
        setState(() {
          _currMapType = "Satellite";
        });
        _animationController.reverse();
      },
      tooltip: 'Satellite',
      child: const Icon(Icons.satellite_alt),
    );
  }

  Widget osm() {
    return FloatingActionButton(
      heroTag: "osm",
      onPressed: () {
        setState(() {
          _currMapType = "OSM ";
        });
        _animationController.reverse();
      },
      tooltip: 'Open Street Map',
      child: const Icon(Icons.map),
    );
  }

  Widget toggle() {
    return FloatingActionButton(
      heroTag: "toggle",
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, TileLayer> mapTypes = {
      "OSM": openStreetMapTileLayer,
      "Satellite": satelliteTileLayer,
      // "Terrain": TerrainTileLayer,
    };
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: FlutterMap(
        options: MapOptions(
            initialCenter: LatLng(widget.lat, widget.long),
            initialZoom: 15,
            interactionOptions:
                const InteractionOptions(flags: InteractiveFlag.all)),
        children: [
          mapTypes[_currMapType] ?? Container(),
          MarkerLayer(
            markers: markers,
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Transform(
          //   transform: Matrix4.translationValues(
          //     0.0,
          //     _translateButton.value * 3.0,
          //     0.0,
          //   ),
          //   child: terrain(),
          // ),
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value * 2.0,
              0.0,
            ),
            child: satellite(),
          ),
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value,
              0.0,
            ),
            child: osm(),
          ),
          toggle(),
        ],
      ),
    );
  }
}
