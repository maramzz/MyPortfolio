# My Portfolio

A personal portfolio mobile application built with Flutter. It presents my profile, interests, skills, and projects in a clean, simple interface.

## Features

- Animated splash screen
- Multi-page portfolio navigation with push and pop behavior
- About, skills, experience, work, and contact sections
- Project cards link to their GitHub repositories
- Mobile navigation menu
- Light and dark themes, starting in light mode
- External links for email, WhatsApp, GitHub, and resume
- Custom application branding and logo
- Responsive Material 3 interface
- Editorial typography

## Technologies

- Flutter
- Dart
- Material 3
- URL Launcher

## Project Status

This portfolio is under active development. More personal information, portfolio sections, and project details will be added over time.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- An IDE with Flutter support, such as Visual Studio Code

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/maramzz/MyPortfolio.git
   ```

2. Enter the project directory:

   ```bash
   cd MyPortfolio
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

## Project Structure

```text
lib/
  main.dart                 # Application entry point
  splash_screen.dart        # Animated launch screen
  pages/
    home_page.dart          # Portfolio home page
    about_page.dart         # Personal information
    skills_page.dart        # Technical skills
    experience_page.dart    # Work and certifications
    projects_page.dart      # Selected work
    contact_page.dart       # Contact information
    portfolio_page.dart     # Shared page layout and cards
  theme/
    app_theme.dart          # Light and dark themes
    theme_mode_controller.dart # Theme selection and saved preference
assets/
  images/
    logo.png                # Application logo
```

## Author

**Maram**

GitHub: [maramzz](https://github.com/maramzz)
