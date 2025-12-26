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
    
    var body: some View {
        VStack(spacing: 20) {
            
            Group{
                if let image = viewModel.outputImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .cornerRadius(12)
                }else{
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 300)
                        .overlay{
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
