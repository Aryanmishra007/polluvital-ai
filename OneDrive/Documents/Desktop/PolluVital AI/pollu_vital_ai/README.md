# PolluVital AI

**Tagline:** _Your phone warns you before pollution harms your health_

PolluVital AI is an on-device Flutter + TinyML health assistant for Delhi/NCR users. It combines:
- 30s face scan (rPPG) for HR/RR/SpO2/stress
- 10s breathing audio classification (normal/wheezing/crackles)
- Delhi AQI context via AQICN token API
- Multimodal temporal risk prediction for next 1–4 hours

## Features
- 100% local inference after app/model setup (AQI cached for offline mode)
- Hindi + English UI
- Risk score (0–100), alerts, personalized advice
- Weekly local trend graph (Hive)
- One-tap PDF report export
- Privacy-first notice (no biometrics uploaded)

## Project Structure
```text
pollu_vital_ai/
├─ android/
├─ assets/
│  ├─ i18n/
│  ├─ models/
│  └─ samples/
├─ lib/
│  ├─ l10n/
│  ├─ models/
│  ├─ screens/
│  ├─ services/
│  └─ widgets/
├─ training/
│  ├─ PolluVital_Training.ipynb
│  ├─ dataset_guide.md
│  └─ labels_sample.csv
├─ demo_video_script.md
└─ pubspec.yaml
```

## Setup
1. Install Flutter 3.24+ and Android Studio.
2. `flutter pub get`
3. Add your AQI token inside app settings dialog (or use `.env` pattern if preferred).
4. Place TFLite models in `assets/models/`:
   - `rppg_physnet.tflite`
   - `audio_breath_cnn.tflite`
   - `fusion_lstm.tflite`
5. Run: `flutter run`

## Run on Web (Local)
1. Ensure Flutter is in your PATH.
2. Enable web once: `flutter config --enable-web`
3. Get packages: `flutter pub get`
4. Run in browser: `flutter run -d chrome`

## Deploy (Netlify)
1. Push this project to GitHub.
2. In Netlify, import the repository.
3. Build settings are already configured in `netlify.toml`:
   - Build command installs Flutter, gets dependencies, and builds web release.
   - Publish directory is `build/web`.
   - SPA routing is configured to serve `index.html` for all routes.
4. Deploy.
5. After deploy, open app -> **Set AQI Token** and save your AQICN token.

## Deploy (GitHub Actions - Automatic)
1. Push this project to GitHub.
2. In your GitHub repository settings, add these secrets:
   - `NETLIFY_AUTH_TOKEN`: Your Netlify personal access token
   - `NETLIFY_SITE_ID`: Your Netlify site ID
3. Push to `main` branch - deployment happens automatically.
4. After first deploy, open app -> **Set AQI Token** and save your AQICN token.

Note: On web, if live AQI fetch is blocked by network/CORS and no cache exists yet, the app uses a safe demo AQI fallback so the full flow remains usable.

## AQI Token (aqicn.org)
1. Open https://aqicn.org/data-platform/token/
2. Sign up for free account.
3. Copy token.
4. Open app -> **Set AQI Token** -> paste token -> Save.

## Screenshots (placeholders)
- `docs/screenshots/home.png`
- `docs/screenshots/scan.png`
- `docs/screenshots/dashboard.png`
- `docs/screenshots/trends.png`

## Demo Video Script
See [`demo_video_script.md`](demo_video_script.md).

## Resume Bullets
- Built **PolluVital AI**, an on-device multimodal health-risk predictor combining camera rPPG, respiratory audio AI, and AQI fusion.
- Optimized TinyML pipeline (PhysNet/CNN/LSTM -> int8 TFLite) for real-time inference on Android.
- Implemented privacy-first Flutter app with bilingual UX, local trends, and one-tap PDF report exports.

## Privacy
PolluVital AI does not upload face video or breathing audio. Inference runs locally on-device. AQI calls only fetch public environmental data.

## Built by
**Aryan – B.Tech CSE 2nd Year, K.R. Mangalam University**

