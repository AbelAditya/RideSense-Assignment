# RideSense App

RideSense is a Flutter-based mobile application that displays a map, allows users to switch between different map types (such as OpenStreetMap and Satellite views), and places markers based on the user's current location or a manually specified location.

## Features

- Display map with different map types (OpenStreetMap, Satellite).
- Add a marker to the map based on the user's current location.
- Switch between map types.
- Display user-entered location and current location on the map.

## Prerequisites

Before running this project, you must have the following installed:

1. **Flutter SDK**: You can install Flutter SDK from [here](https://flutter.dev/docs/get-started/install).
2. **Android Studio or VS Code**: To run and debug Flutter apps.
3. **Git**: To clone the project from the repository.

## Setup Instructions

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-username/rideSense.git
cd rideSense
```

### Step 2: Install Flutter Dependencies

```bash
flutter pub get
```

### Step 3: Run The App

```bash
flutter run
```

## Packages Used
1. `flutter_map`
    - A popular package used to display maps in a Flutter app. It allows adding different types of map tiles and markers to create an interactive map experience.

2. `latlong2`
    - This package is a fork of the original `latlong` package and is used to handle geographical coordinates (latitude and longitude). It is useful for positioning markers or for centering the map at specific coordinates.

3. `geolocator`
    - This package is a fork of the original latlong package and is used to handle geographical coordinates (latitude and longitude). It is useful for positioning markers or for centering the map at specific coordinates.

4. `permission_handler`
    - This package is used to request and check permissions at runtime. It helps to ensure that the user has granted necessary permissions like location access.

## Screenshots
