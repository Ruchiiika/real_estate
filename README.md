# Property Ease - Flutter Property App

A comprehensive property rental and listing mobile application built with Flutter. This app provides a modern, user-friendly interface for browsing, searching, and managing properties.

## 🏗️ Features

### ✅ Core Features
- **Property Listing** - Browse properties on the home page
- **Property Details** - Detailed property information with image carousel
- **Category-wise Filter** - Filter properties by type and category
- **Navigation** - Smooth navigation between screens
- **Dummy Data** - Pre-populated with sample properties

### ➕ Extra Features
- **🔍 Search Functionality** - Real-time property search
- **👤 User Authentication** - Login/Signup with validation
- **❤️ Wishlist** - Save and manage favorite properties
- **🎞️ Property Reels** - TikTok-style property videos
- **📍 Map Integration** - Google Maps with property locations
- **🧾 Property Posting** - Add new properties (UI complete)
- **⚙️ Bottom Navigation** - Modern navigation bar

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd property_ease
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Structure

```
lib/
│
├── main.dart                    # App entry point
├── models/
│   └── property_model.dart     # Property and User models
├── providers/
│   ├── property_provider.dart  # Property state management
│   └── user_provider.dart      # User state management
├── pages/
│   ├── home_page.dart          # Main property listing
│   ├── property_detail_page.dart # Property details
│   ├── login_page.dart         # Authentication
│   ├── wishlist_page.dart      # Saved properties
│   ├── add_property_page.dart  # Add new property
│   ├── reels_page.dart         # Property videos
│   └── map_page.dart          # Map with locations
├── widgets/
│   ├── property_card.dart      # Property display card
│   ├── category_chip.dart      # Category filter chips
│   ├── bottom_nav.dart         # Bottom navigation
│   ├── search_bar.dart         # Search and filter
│   └── reel_tile.dart         # Video reel tile
└── data/
    └── dummy_data.dart         # Sample data
```

## 🎨 Design Features

- **Modern UI** - Clean, modern interface with Material Design 3
- **Google Fonts** - Beautiful typography using Poppins font
- **Smooth Animations** - Engaging user interactions
- **Responsive Design** - Works on various screen sizes
- **Dark Theme Support** - Consistent theming throughout

## 🔧 Key Technologies

- **Flutter** - Cross-platform mobile development
- **Provider** - State management
- **Google Maps** - Map integration
- **Video Player** - Property video playback
- **Cached Network Image** - Optimized image loading
- **Carousel Slider** - Image galleries
- **Image Picker** - Photo selection

## 📋 Main Screens

1. **Home Screen** - Property listings with search and filters
2. **Property Details** - Comprehensive property information
3. **Search & Filter** - Advanced property filtering
4. **Wishlist** - Saved favorite properties
5. **Add Property** - Property listing form
6. **Reels** - Short property videos
7. **Map View** - Properties on Google Maps
8. **Authentication** - Login and signup

## 🎯 Future Enhancements

- **Firebase Integration** - Real backend connectivity
- **Chat System** - In-app messaging with property owners
- **Push Notifications** - Property alerts and updates
- **Advanced Search** - More filtering options
- **Property Analytics** - View statistics for owners
- **Social Features** - Share properties, reviews

## 📝 Usage

### For Property Seekers
1. Browse properties on the home screen
2. Use search and filters to find specific properties
3. View detailed property information
4. Save properties to wishlist
5. Contact property owners directly
6. View properties on map

### For Property Owners
1. Create an account and login
2. Post new properties with images
3. Manage your property listings
4. Track property views and interest

## 🛠️ Development

### Adding New Features
1. Create models in `models/` directory
2. Add providers for state management
3. Create UI pages in `pages/` directory
4. Build reusable widgets in `widgets/`
5. Update navigation in `main.dart`

### Testing
```bash
flutter test
```

### Building for Release
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Figma design inspiration from Property Ease UI Kit
- Unsplash for beautiful property images
- Flutter team for the amazing framework

---

**Built with ❤️ using Flutter**