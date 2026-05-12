# PolluVital AI Demo Script (2 Minutes)

Hi everyone, I am Aryan, and this is **PolluVital AI** — “Your phone warns you before pollution harms your health.”

In Delhi NCR, pollution spikes can affect heart rate, breathing, and stress before people realize it. PolluVital AI predicts this risk using only your smartphone camera, microphone, and AQI context.

On the home screen, I start a quick health scan.  
The app requests camera and microphone permissions, then records a 30-second face video and 10-second breathing sample.

From the face video, on-device rPPG estimates heart rate, respiratory rate, SpO2, and stress level.  
From breathing audio, the model classifies normal, wheezing, or crackles.

Now the app combines vitals, breathing signal, and current Delhi AQI in a lightweight fusion LSTM model.  
In seconds, it predicts the next 1 to 4 hours of risk.

Here on the dashboard, you can see:
- Live vitals cards
- Risk score with color alert
- Predicted HR rise and breathing risk
- Personalized advice in English or Hindi

If internet is unavailable, the app still works using cached AQI and on-device AI.

Next, I open Weekly Trends.  
All scans are stored locally, and this chart helps users track how pollution impacts their body over time.

Finally, with one tap, I export a PDF report for doctor sharing or self-monitoring.

Most importantly: this is privacy-first. Face and audio data never leave the phone.

That’s PolluVital AI — production-ready on-device health intelligence for polluted cities.

