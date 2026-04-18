// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import MediaPlayer

@MainActor
struct MPVolumeViewRepresentable: UIViewRepresentable {
    @Binding var volume: Float
    func makeUIView(context: Context) -> MPVolumeView {
        let mpView = MPVolumeView()
        
        for subview in mpView.subviews {
            if let slider = subview as? UISlider {
                slider.addTarget(
                    context.coordinator,
                    action: #selector(Coordinator.valueChanged(_:)),
                    for: .valueChanged
                )
                context.coordinator.slider = slider
                Task{
                    try? await Task.sleep(nanoseconds: 1_000_000)
                    slider.value = self.volume
                }
                break
            }
        }
        return mpView
    }
    
    func updateUIView(_ uiView: MPVolumeView, context: Context) {
        if let slider = context.coordinator.slider {
            slider.value = volume
        } else {
            for subview in uiView.subviews {
                if let slider = subview as? UISlider {
                    context.coordinator.slider = slider
                    slider.value = volume
                    break
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    @MainActor
    class Coordinator: NSObject {
        var parent: MPVolumeViewRepresentable
        weak var slider: UISlider?
        private var volumeObservation: NSKeyValueObservation?
        
        init(_ parent: MPVolumeViewRepresentable) {
            self.parent = parent
            super.init()
            startObservingSystemVolume()
        }

        private func startObservingSystemVolume() {
            guard (volumeObservation == nil) else { return }
            let audioSession = AVAudioSession.sharedInstance()
            try? audioSession.setActive(true)
            volumeObservation = audioSession.observe(\AVAudioSession.outputVolume, options: [.initial, .new, .prior]) { [weak self] session, _ in
                Task { @MainActor in
                    self?.parent.volume = session.outputVolume
                }
            }
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            parent.volume = sender.value
        }
    }
}
