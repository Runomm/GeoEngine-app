# GeoEngine app

[Türkçe](README.tr.md)

The first, very small client for [GeoEngine](https://github.com/Runomm/GeoEngine-Backend). It has a single screen: pick a photo from the gallery, send it to the backend's `/analyze` endpoint, and read the JSON that comes back.

This isn't a complete Flutter project, just `main.dart` and the dependency list (`http`, `image_picker`). To run it, create a project with `flutter create`, replace `lib/main.dart` with this file and add the two packages. The backend URL is hard-coded as `http://localhost:8000/analyze`.

The newer client, with a map view, lives in [GeoEngine-Backend/app](https://github.com/Runomm/GeoEngine-Backend/tree/main/app). The documents are in [GeoEngine-web](https://github.com/Runomm/GeoEngine-web).
