# Maram Zarrouk — Portfolio

A personal portfolio app built with Flutter. It presents my background as a Computer Science student, along with my technical skills, experience, projects, and contact information.

## Features

- Animated splash screen and logo transition to the home page
- Separate About, Skills, Experience, Work, and Contact pages
- Push and pop page navigation
- Light and dark themes; the app starts in light mode
- Tappable project cards for the SkillUp and CampusFind GitHub repositories
- Contact actions for email, WhatsApp, GitHub, and my resume
- Responsive Material 3 layouts

## Built With

- Flutter and Dart
- Material 3
- `url_launcher` for external links

## Run Locally

### Requirements

- Flutter SDK compatible with the Dart constraint in `pubspec.yaml`
- An available Flutter target, such as an Android or iOS device, desktop, or browser

### Setup

```bash
git clone https://github.com/maramzz/MyPortfolio.git
cd MyPortfolio
flutter pub get
flutter run
```

To run on a specific device, list available targets with `flutter devices`, then use `flutter run -d <device-id>`.

## Verify

```bash
flutter analyze
flutter test
```

## Project Structure

```text
lib/
  main.dart
  splash_screen.dart
  pages/
    home_page.dart
    about_page.dart
    skills_page.dart
    experience_page.dart
    projects_page.dart
    contact_page.dart
    portfolio_page.dart
  theme/
    app_theme.dart
    theme_mode_controller.dart
assets/
  images/
    logo.png
```

## Projects

- [SkillUp](https://github.com/maramzz/SkillUp) — React learning platform.
- [CampusFind](https://github.com/maramzz/CampusFind) — campus lost-and-found platform; work in progress.

## Author

**Maram Zarrouk**

- GitHub: [@maramzz](https://github.com/maramzz)
- Email: [maramzarrouk0@gmail.com](mailto:maramzarrouk0@gmail.com)
