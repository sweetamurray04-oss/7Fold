//
//  GameFinished.swift
//  Sins
//
//  Created by user on 2/17/26.
//

import Foundation
import Combine

enum States {
    case menu
    case game
    case credits
}

final class GameState: ObservableObject {
    @Published var state: States = .menu
    @Published var finished: Bool = false
}
