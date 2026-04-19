//
//  File.swift
//  SwiftUIVolume
//
//  Created by Phineas Guo on 2026/4/19.
//

import SwiftUI
import AVFoundation

public enum VolumeChangeType {
    case up
    case down
    case unknown
}

@available(iOS 17.0, *)
struct VolumeButtonPressed: ViewModifier {
    let handle: ((VolumeChangeType) -> Void)
    let volumeFixed: Bool
    @State var volume: Float = 0
    @State var vol: Float = 0
    @State var observation = false
    @State var notProcessing = true
    func body(content: Content) -> some View {
        
        return (content
            .modifier(MPVolume(volume: $volume))
            .onAppear {
                Task {
                    try? await Task.sleep(nanoseconds: 1_000_000)
                    let currentVol = volume
                    if currentVol == 0 {
                        volume = 0.10
                        vol = volume
                    } else if currentVol == 1 {
                        volume = 0.90
                        vol = volume
                    } else {
                        volume = currentVol
                        vol = currentVol
                    }
                    observation = true
                }
            }
            .onChange(of: volume, { oldValue, newValue in
                if notProcessing {
                    if observation{
                        notProcessing = false
                        if newValue > oldValue {
                            handle(.up)
                            
                        } else if newValue < oldValue{
                            handle(.down)
                            
                        } else {
                            handle(.unknown)
                            
                        }
                        if volumeFixed {
                            volume = vol
                        }
                        Task {
                            try? await Task.sleep(nanoseconds: 1_000_000)
                            notProcessing = true
                        }
                        
                    }
                    
                }
                
            })
        )
    }
}

extension View {
    /// Observer for volume button pressed
    /// - Parameters:
    ///   - handle: Closure at the time of event occurrence
    ///   - volumeFixed: A bool value that decided to change the volume after pressing the volume button
    ///
    /// This modifier may sometimes identify incorrect button types or volume changes.
    @available(iOS 17.0, *)
    public func onVolumeButtonPressed(_ handle: (@escaping (VolumeChangeType) -> Void), volumeFixed: Bool = true) -> some View {
        self.modifier(VolumeButtonPressed(handle: handle, volumeFixed: volumeFixed))
        
    }
}

