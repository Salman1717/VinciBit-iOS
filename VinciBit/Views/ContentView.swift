//
//  ContentView.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 25/12/25.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = VinciBitViewModel()

    @State private var showImagePicker = false
    @State private var showGrid = true

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // MARK: - Image Preview + Grid
                imagePreviewSection

                // MARK: - Instruction Section
                instructionSection

                // MARK: - Controls
                controlsSection

                // MARK: - Palette Preview
                paletteSection
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                // Use an explicit Binding to avoid relying on $viewModel.inputImage projection
                ImagePicker(image: Binding(
                    get: { viewModel.inputImage },
                    set: { viewModel.inputImage = $0 }
                ))
            }
        }
    }

    // Compute the logical active color id from the current instruction step (if any).
    private var activeColorIDForCurrentStep: Int? {
        guard !viewModel.instructions.isEmpty else { return nil }

        let step = viewModel.instructions[viewModel.currentStepIndex]

        guard step.type == .draw else { return nil }
        guard step.drawMode == .byColor else { return nil }

        return step.colorID
    }

}


private extension ContentView {

    var imagePreviewSection: some View {
        Group {
            // use displayGrid & logicalGrid that must be provided by the ViewModel
            if let image = viewModel.outputImage,
               let displayGrid = viewModel.displayGrid,
               let logicalGrid = viewModel.logicalGrid {

                GeometryReader { geo in
                    ZStack {

                        // Base image
                        if !showGrid{
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width)
                                .cornerRadius(12)
                        }

                        // Pixel overlay
                        if showGrid {
                            PixelGridOverlay(
                                displayGrid: displayGrid,
                                logicalGrid: logicalGrid,
                                activeColorID: activeColorIDForCurrentStep
                            )
                        }
                    }
                }
                .frame(height: 300)

            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 300)
                    .overlay {
                        Text("No Image")
                            .foregroundStyle(.secondary)
                    }
            }
        }
    }
}


private extension ContentView {

    var instructionSection: some View {
        Group {
            if !viewModel.instructions.isEmpty {
                let step = viewModel.instructions[viewModel.currentStepIndex]

                VStack(spacing: 10) {

                    Text(step.title)
                        .font(.headline)

                    Text(step.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    // We keep showing a color swatch for UX, but logic uses colorID.
                    if let color = step.color {
                        Rectangle()
                            .fill(color)
                            .frame(width: 44, height: 44)
                            .cornerRadius(6)
                    }

                    HStack {
                        Button("Previous") {
                            viewModel.currentStepIndex =
                                max(0, viewModel.currentStepIndex - 1)
                        }

                        Button("Next") {
                            viewModel.currentStepIndex =
                                min(
                                    viewModel.instructions.count - 1,
                                    viewModel.currentStepIndex + 1
                                )
                        }
                    }
                }
                .padding(.top)
            }
        }
    }
}

private extension ContentView {

    var controlsSection: some View {
        VStack(spacing: 12) {

            Button {
                showImagePicker = true
            } label: {
                Label("Pick Image", systemImage: "photo.on.rectangle")
            }
            .buttonStyle(.bordered)

            Button {
                viewModel.runInference()
            } label: {
                Label("Run Inference", systemImage: "bolt.fill")
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.inputImage == nil)

            Toggle("Show Grid", isOn: $showGrid)
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 6) {
                Text("Grid Size: \(viewModel.gridSize) × \(viewModel.gridSize)")
                    .font(.subheadline)

                Slider(
                    value: Binding(
                        get: { Double(viewModel.gridSize) },
                        set: { viewModel.gridSize = Int($0) }
                    ),
                    in: 8...48,
                    step: 8
                )
            }
        }
    }
}

private extension ContentView {

    var paletteSection: some View {
        Group {
            if !viewModel.palette.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.palette) { p in
                            VStack {
                                Rectangle()
                                    .fill(p.color)
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(4)

                                Text("\(p.count)")
                                    .font(.caption2)
                            }
                        }
                    }
                }
            }
        }
    }
}


// Preview
#Preview {
    ContentView()
}
