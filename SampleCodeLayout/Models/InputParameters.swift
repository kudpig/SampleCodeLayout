//
//  InputParameters.swift
//  SampleCodeLayout
//
//  Created by Shinichiro Kudo on 2021/07/25.
//

import Foundation

enum InputError: Error, LocalizedError {
    case notEnteredError, validationError, dataError
    var errorDescription: String {
        switch self {
        case .notEnteredError:
            return "入力されていない項目があります"
        case .validationError:
            return "数字が入力されていません"
        case .dataError:
            return "入力データに不正があります"
        }
    }
}

struct InputParameters {
    let textX: String?
    let textY: String?
    let textWidth: String?
    let textHeight: String?
    
}

struct InputData {
    
    static let shared = InputData()
    private init() {}
    
    func getModelData(parameters: InputParameters, completion: ((Result<ObjectConstraint, InputError>) -> Void)? = nil) {
        
        guard let textX = parameters.textX,
              let textY = parameters.textY,
              let textWidth = parameters.textWidth,
              let textHeight = parameters.textHeight,
              !textX.isEmpty,
              !textY.isEmpty,
              !textWidth.isEmpty,
              !textHeight.isEmpty else {
            completion?(.failure(.notEnteredError))
            return
        }
        
        guard let intX = NumberFormatter().number(from: textX) as? Int,
              let intY = NumberFormatter().number(from: textY) as? Int,
              let intWidth = NumberFormatter().number(from: textWidth) as? Int,
              let intHeight = NumberFormatter().number(from: textHeight) as? Int else {
            completion?(.failure(.validationError))
            return
        }
        
        let model = ObjectConstraint(topAnchorX: intX,
                                     leftAnchorY: intY,
                                     widthAnchorInt: intWidth,
                                     heightAnchorInt: intHeight)
        
        completion?(.success(model))
    }
    
}
