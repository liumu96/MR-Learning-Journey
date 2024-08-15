//
//  WallArtApp.swift
//  WallArt
//
//  Created by liuxing on 2024/8/15.
//

import SwiftUI

@main
struct WallArtApp: App {
    
    @State private var viewModel = ViewModel()
    
    init() {
        ImpactParticleSystem.registerSystem()
        ProjectileComponent.registerComponent()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }.windowStyle(.plain)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(viewModel)
        }
        
        WindowGroup(id: "doodle_canvas") {
            DoodleView()
                .environment(viewModel)
        }
    }
}
