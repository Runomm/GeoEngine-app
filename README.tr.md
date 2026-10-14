# GeoEngine app

[English](README.md)

[GeoEngine](https://github.com/Runomm/GeoEngine-Backend) için yazılmış ilk ve çok basit istemci. Tek bir ekranı var: galeriden fotoğraf seçiyorsun, backend'in `/analyze` endpoint'ine gönderiyorsun, dönen JSON'u okuyorsun.

Tam bir Flutter projesi değil; yalnızca `main.dart` ve bağımlılık listesi (`http`, `image_picker`) var. Çalıştırmak için `flutter create` ile bir proje oluştur, `lib/main.dart` dosyasını bununla değiştir ve iki paketi ekle. Backend adresi `http://localhost:8000/analyze` olarak sabit yazılı.

Harita görünümü olan yeni istemci [GeoEngine-Backend/app](https://github.com/Runomm/GeoEngine-Backend/tree/main/app) içinde. Dokümanlar [GeoEngine-web](https://github.com/Runomm/GeoEngine-web) reposunda.
