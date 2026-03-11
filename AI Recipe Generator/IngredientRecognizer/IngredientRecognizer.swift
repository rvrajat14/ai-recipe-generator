//
//  IngredientRecognizer.swift
//  AI Recipe Generator
//
//  Created by Rajat Verma on 07/03/26.
//

import Vision
import CoreML
import UIKit

class IngredientRecognizer {
   

    func detectIngredient(from image: UIImage, completion: @escaping ([String]) -> Void) {
        
        guard let model = try? VNCoreMLModel(for: MLModel()),
              let cgImage = image.cgImage else { return }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                completion([])
                return
            }
            
            let ingredients = results.prefix(3).map { $0.identifier }
            
            completion(ingredients)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        
        DispatchQueue.global().async {
            try? handler.perform([request])
        }
    }
}
