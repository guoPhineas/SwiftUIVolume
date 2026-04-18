//
//  ContentView.swift
//  SwiftUIVolume-Demo
//
//  Created by Phineas Guo on 2026/4/18.
//

import SwiftUI
import SwiftUIVolume

struct ContentView: View {
    // The initialization value is invalid, you should manually adjust it after the view appeared (like onAppeal below)
    @State var volume: Float = 0
    var body: some View {
        VStack {
            Text("Volume: \(volume)")
            Slider(value: $volume)
                .animation(nil, value: volume)
                .systemVolume($volume)
        }
        .padding()
        
        .onAppear {
            // If you want to change the system volume when the view appeared, you should await few seconds before you set.
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000)
                volume = 0.05
            }
        }
    }
}

#Preview {
    ContentView()
}
