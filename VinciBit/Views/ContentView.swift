//
//  ContentView.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 25/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = VinciBitViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: viewModel.isModelLoaded ? "checkmark.seal.fill" : "hourglass")
                .font(.system(size: 64))
                .foregroundColor(viewModel.isModelLoaded ? .green : .orange)
            
            Text(viewModel.isModelLoaded
                 ? "VinciBit Core ML Ready"
                 : "Loading Core ML…")
                .font(.title3)
                .fontWeight(.medium)
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
