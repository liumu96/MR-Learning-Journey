//
//  ViewModel.swift
//  WallArt
//
//  Created by liuxing on 2024/8/15.
//

import Foundation
import Observation

enum FlowState {
    case idle
    case intro
    case projectileFlying
    case updateWallArt
}

@Observable
class ViewModel {
    
    var flowState = FlowState.idle
}
