//
//  Main.swift
//  Sins
//
//  Created by user on 2/17/26.
//

import SwiftUI
import SpriteKit
import UIKit

struct Main: View {
    @StateObject var gameState = GameState()
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var device: Device {
        UIDevice.current.userInterfaceIdiom == .phone ? .phone : .pad
    }
    
    var size: CGSize {
        CGSize(width: screenWidth, height: screenHeight)
    }
    
    var body: some View {
        switch gameState.state {
        case .menu:
            ZStack {
                Color.black.ignoresSafeArea()
                HStack {
                    if gameState.finished {
                        SpriteView(scene: WinScene(size: size))
                    } else {
                        Image("Main_Hero")
                            .resizable()
                            .scaledToFit()
                    }
                    
                    VStack(spacing: 10) {
                        HStack {
                            Image("7")
                                .resizable()
                                .scaledToFit()
                            Image("FOLD")
                                .resizable()
                                .scaledToFit()
                        }
                        
                        
                        Button("Start Game") {
                            gameState.state = .game
                        }
                        .foregroundStyle(Color.cyan)
                        
                        
                        Button("Credits") {
                            gameState.state = .credits
                        }
                        .foregroundStyle(Color.white)
                        
                        Button("Exit") {
                            exit(0)
                        }
                        .foregroundStyle(Color.white)
                        
                    }
                }
                .chalk(device == .phone ? .title : .largeTitle)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(10)
                .frame(maxWidth: .infinity)
            }
            .onAppear {
                SoundManager.shared.playBackgroundMusic(fileName: gameState.finished == true ? "endingmusic" : "Mainmenusound")
            }
            .statusBarHidden()
        case .game:
            SpriteView(scene: GameScene(size: size, device: device, gameState: gameState))
                .ignoresSafeArea()
                .statusBarHidden()
        case .credits:
            Credit(device: device, gameState: gameState)
                .statusBarHidden()
        }
    }
}

#Preview {
    Main()
}
