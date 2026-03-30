//
//  SoundEffect.swift
//  Sins
//
//  Created by Ajanae Murray on 2/17/26.
//

import AVFoundation

class SoundManager {
   static let shared = SoundManager()
   private var soundEffectPlayer: AVAudioPlayer?
   private var backgroundMusicPlayer: AVAudioPlayer?

    func playBackgroundMusic(fileName: String, loop: Bool = true) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("error: BGM not found \(fileName).mp3")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = loop ? -1 : 0
            backgroundMusicPlayer?.volume = 1.0
            backgroundMusicPlayer?.play()
        } catch {
            print("error could not play BGM")
        }
        
    }
    func playImportedSound(named soundName: String) {
        if let url = Bundle.main.url(forResource: soundName, withExtension: ".mp3"){
            do {
                soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
                soundEffectPlayer?.play()
                
                } catch {
                print("Error playing Sound \(error.localizedDescription)")
            }
       } else {
           print ("Sound file not found \(soundName)")
        }
    }
    func playSoundEffect(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
           print("Error Sound effect file not found \(fileName).mp3")
          return
       }
       do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
           soundEffectPlayer?.play()
        } catch {
            print("error could not play sound effects")
        }
   }
    
    func stopSound() {
        backgroundMusicPlayer?.stop()
    }
    
    func stopSoundEffect() {
        soundEffectPlayer?.stop()
    }
}


