//
//  VinciBitViewModel.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 25/12/25.
//

import Foundation
import Combine


final class VinciBitViewModel: ObservableObject {
    
    @Published var isModelLoaded: Bool = false
    
    private let mlservice = MLModelService.shared
    
    init() {
        loadModel()
    }
    
    private func loadModel(){
        _ = mlservice.model
        isModelLoaded = true
    }
    
    
}
