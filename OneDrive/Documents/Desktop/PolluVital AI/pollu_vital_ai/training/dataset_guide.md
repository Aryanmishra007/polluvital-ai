# PolluVital AI Dataset Collection Guide

## 1. Goal
Create aligned multimodal samples:
- 30s face video (for rPPG features)
- 10s breathing audio
- AQI value at capture time
- Ground-truth or pseudo-labels for next 1–4 hour degradation

## 2. Folder Format
```text
dataset/
├─ subject_001/
│  ├─ session_2026-04-01_09-10/
│  │  ├─ face.mp4
│  │  ├─ breath.wav
│  │  └─ meta.json
├─ subject_002/
└─ labels.csv
```

## 3. Data Capture Protocol
1. Keep phone stable, face centered, natural light.
2. Record 30s video at 30 FPS minimum.
3. Record 10s breathing sound in quiet room.
4. Log AQI and PM2.5 at same timestamp.
5. Re-capture true vitals after 1h, 2h, 4h to build labels.

## 4. Suggested Public Data Sources
- rPPG pretraining: UBFC-rPPG, PURE
- Respiratory sounds: ICBHI Respiratory Sound Database
- AQI: aqicn historical references or CPCB aligned feeds

## 5. labels.csv Fields
- sample_id
- subject_id
- timestamp
- video_path
- audio_path
- aqi
- hr_now
- rr_now
- spo2_now
- stress_now
- breath_class (normal/wheezing/crackles)
- hr_delta_1h
- hr_delta_2h
- hr_delta_4h
- breath_risk_1h
- breath_risk_2h
- breath_risk_4h
- risk_score_1h
- risk_score_2h
- risk_score_4h

