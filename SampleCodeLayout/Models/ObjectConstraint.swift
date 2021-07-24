//
//  ObjectConstraint.swift
//  SampleCodeLayout
//
//  Created by Shinichiro Kudo on 2021/07/23.
//

import Foundation

struct ObjectConstraint {
    let topAnchorX: Int
    let leftAnchorY: Int
    let widthAnchorInt: Int
    let heightAnchorInt: Int
    
    static func createDefaultConstraint() -> ObjectConstraint {
        return ObjectConstraint(topAnchorX: 50, leftAnchorY: 50, widthAnchorInt: 50, heightAnchorInt: 50)
    }
}
