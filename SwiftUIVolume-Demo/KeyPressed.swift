//
//  ContentView.swift
//  SwiftUIVolume-Demo
//
//  Created by Phineas Guo on 2026/4/18.
//

import SwiftUI
import SwiftUIVolume

struct ContentView: View {
    @State var button: VolumeChangeType = .unknown
    var body: some View {
        VStack {
            if button == .down {
                Text("Key down")
            } else if (button == .up) {
                Text("Key up")
            } else {
                Text("Wait")
            }
        }
        .onVolumeButtonPressed({ type in
            button = type
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                button = .unknown
            }
        }, volumeFixed: false)
        
        .padding()
    }
}

#Preview {
    ContentView()
}
