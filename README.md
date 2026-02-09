# scramblemonster_neo

A Flutter word scramble game.

## GitHub Pages Deployment

This project is automatically deployed to GitHub Pages when changes are pushed to the `main` branch.

### Live Demo
Visit: https://pek0hara.github.io/scramblemonster_neo/

### Setup Instructions

1. Enable GitHub Pages in your repository settings:
   - Go to Settings > Pages
   - Under "Source", select "GitHub Actions"

2. Push changes to the `main` branch to trigger automatic deployment

### Local Development

```bash
# Install dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Build for web
flutter build web --release --base-href=/scramblemonster_neo/
```
