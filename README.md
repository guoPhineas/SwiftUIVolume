# SwiftUIVolume

SwiftUIVolume is a Swift Package that allows you to get or set the system volume and observe if the volume button was pressed in your SwiftUI app. This package is designed for iOS and works only on real devices (not in the simulator).

## Features
- Get the current system volume
- Set the system volume programmatically
- Observe if the volume button was pressed
- Easy integration with SwiftUI

## Important Notes
- **Initialization Value:** The initial value may be invalid. You should manually adjust the volume after the view appears to ensure correct behavior.
- **Device Requirement:** This package only works on real iOS devices. It does **not** work in the iOS simulator.

## Installation

### Swift Package Manager
Add the following to your `Package.swift`:

```swift
.package(url: "https://github.com/guoPhineas/SwiftUIVolume.git", branch: "main")
```

Or use Xcode:
1. Go to **File > Add Packages...**
2. Enter the repository URL
3. Add the package to your project

## Usage

Import the package in your SwiftUI view:

```swift
import SwiftUIVolume
```

Use the provided API to get or set the system volume. See the demo app for a complete example.

### Volume change and observation

```swift
struct ContentView: View {
    @State var volume: Float = 0

    var body: some View {
        VStack {
            Text("Volume: \(volume)")
            Slider(value: $volume)
            HStack(spacing: 20) {
                Button("Set 20%"){
                    volume = 0.20
                }
                Button("Set 50%"){
                    volume = 0.50
                }
            }
        }
        .padding()
        .onAppear {
            // If you want to change the system volume when the view appeared, you should await few seconds for the MPVolumeView to load before you set.
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000)
                volume = 0.05
            }
        }
    }
}
```

### Observes the volume button pressed

```swift
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
```

## Demo App
A demo app is included in the `SwiftUIVolume-Demo` folder. Open `SwiftUIVolume.xcodeproj` and run the demo on a real iOS device to see the package in action.

## License
See [LICENSE](LICENSE) for details.
