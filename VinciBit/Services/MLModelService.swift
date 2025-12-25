//
//  MLModelService.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 25/12/25.
//

import Foundation
import CoreML

final class MLModelService{
    
    static let shared = MLModelService()
    
    let model: VinciBitQuantizer
    
    private init(){
        do{
            let config = MLModelConfiguration()
            config.computeUnits = .all
            
            self.model = try VinciBitQuantizer(configuration: config)
            
            print("VinciBitQuantizer loaded")
        } catch {
            fatalError("❌ Failed to load VinciBitQuantizer: \(error)")
        }
    }
}
