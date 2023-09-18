# RunJam
RunJam is an iOS application made using Swift, SwiftUI, CoreMotion, and the Spotify iOS SDK to enhance your running experience. It allows you to select your favorite playlists, analyzes your running cadenc ethrough CoreMotion, and dynamically finds and plays songs from your chosen playlists that match your running tempo. With RunJam, you can both enjoy music on your run and use it as a tool to run faster!

## Features
- **Playlist selection:** Choose from your Spotify playlists to create a personalized running soundtrack
- **Cadence:** Utilize the CoreMotion framework to accurately measure your running cadence in real-time
- **Spotify Integration:** Enjoy your favorite Spotify tracks without leaving the app
- **Playback Control:** Pause, play, skip, and control volume directly from the RunJam interface
- **Cadence and Tempo Updates:** Continuously monitor your running cadence and song tempo as you run.

## Getting Started
#### Prerequisites
Before you begin, you'll need the following:
- XCode
- An iPhone

### Installation 
1. Clone the repository:
   ```shell
   git clone https://github.com/AlisRyan/RunJam.git
2. Open the project in XCode
3. Configure your Spotify API credentials
   - Create a Spotify Developer account and register your application
   - Update the `SpotifyConfig.swift` file with your client ID and redirect URI
4. Build and run the app on your iPhone!

### Usage
1. Sign in with your Spotify account
2. Select your favorite playlists for your running session
3. Start your run, and RunJam will begin tracking your cadence
4. Enjoy a tailored playlist that matches your running tempo
5. Use the playback controls to manage your music while you run


