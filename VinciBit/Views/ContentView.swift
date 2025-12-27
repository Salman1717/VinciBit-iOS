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
