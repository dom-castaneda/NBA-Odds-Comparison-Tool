# NBA-Odds-Comparison-Tool
A tool that compares odds of head-to-head matches of the NBA from various Australian Bookmakers. Odds data is taken from The Odds API. 
---

## 📌 Features
- Compare odds across multiple bookmakers
- View match-by-match odds in a clean UI
- Fast data fetching service layer
- Cross-platform (Android, iOS, Web, Desktop)

---

## 🛠 Tech Stack
- Flutter (Dart)
- REST API (odds data source)
- Material UI

---

## 📸 Screenshots
(Add screenshots here)

Example:
![Home Screen](assets/screenshots/home.png)

---

## 🚀 How to Run

### 1. API Key Setup

This project uses **The Odds API**.

Create an API key at:
https://the-odds-api.com/

Then add your API key by editing:

```dart
static const String _apiKey = 'YOUR_API_KEY_HERE';
```
inside:
```
lib/services/odds_service.dart
```
Then run:

```bash
git clone https://github.com/dom-castaneda/NBA-Odds-Comparison-Tool.git
cd NBA-Odds-Comparison-Tool
flutter pub get
flutter run 
```