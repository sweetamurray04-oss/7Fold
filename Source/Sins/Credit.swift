//
//  Credit.swift
//  Sins
//
//  Created by user on 2/17/26.
//

import SwiftUI

struct Credit: View {
    let device: Device
    var gameState: GameState
    let texts: [String] = [
        "Thank you",
        "Character Art & Animation - Tamia Brazzell",
        "Environment Art & Animation - Shey Draw",
        "Lead Engineer & Narrative Design - Luk Dushaj",
        "Engineering & Sound Design - A'janae Murray",
        "Music Supervision & Gameplay Footage - June Thomas",
        "Producer & Project Manager - Israel Perez"
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Button(action: {
                        gameState.state = .menu
                    }, label: {
                        Image(systemName: "arrow.left")
                            .font(device == .phone ? .title : .largeTitle)
                            .foregroundStyle(.white)
                    })
                    ForEach(texts, id: \.self) { text in
                        Text(text)
                    }
                    .chalk(device == .phone ? .title : .largeTitle)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                }
                .padding(10)
            }
        }
    }
}

//#Preview {
//    let gameState = GameState()
//    gameState.state = .credits
//    Credit(gameState: gameState)
//}
