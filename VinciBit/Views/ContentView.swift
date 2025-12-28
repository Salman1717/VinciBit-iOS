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
        VStack(spacing: 20) {
            
            Group {
                if let image = viewModel.outputImage {
                    GeometryReader { geo in
                        ZStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width)
                                .cornerRadius(12)
                            
                            // 🔥 PIXEL GRID OVERLAY (Task 6.3)
                            if showGrid, let grid = viewModel.pixelGrid {
                                PixelGridOverlay(
                                    grid: grid,
                                    size: CGSize(
                                        width: geo.size.width,
                                        height: geo.size.width
                                    )
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
            
            if !viewModel.instructions.isEmpty {
                
                let step = viewModel.instructions[viewModel.currentStepIndex]
                
                VStack(spacing: 10) {
                    
                    Text(step.title)
                        .font(.headline)
                    
                    Text(step.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
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
            
            
            
            VStack(spacing: 12){
                Button{
                    showImagePicker = true
                }label: {  
                    Label("Pick Image", systemImage: "photo.on.rectangle")
                }
                .buttonStyle(.bordered)
                
                Button{
                    viewModel.runInference()
                }label:{
                    Label("Run Inference", systemImage: "bolt.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.inputImage == nil )
                
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
            
            if !viewModel.palette.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
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
        .padding()
        .sheet(isPresented: $showImagePicker){
            ImagePicker(image: $viewModel.inputImage)
        }
    }
}


#Preview {
    ContentView()
}
