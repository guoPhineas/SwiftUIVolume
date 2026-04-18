//
//  File.swift
//  SwiftUIVolume
//
//  Created by Phineas Guo on 2026/4/18.
//

import SwiftUI
import AVFoundation

private struct MPVolume: ViewModifier {
    @Binding var volume: Float
    func body(content: Content) -> some View {
        ZStack{
            content
            MPVolumeViewRepresentable(volume: $volume)
                .opacity(0.01)
                .frame(width: 0, height: 0)
        }
    }
    
}

extension View {
    /// Get or change the current system volume
    /// - Parameter volume: The binding value of current system volume.
    ///
    /// The initialization value is invalid, you should manually adjust it after the view appeared.
    ///
    public func systemVolume(_ volume: Binding<Float>) -> some View {
        return self.modifier(MPVolume(volume: volume))
    }
}
