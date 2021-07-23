//
//  TextFieldTitle.swift
//  SampleCodeLayout
//
//  Created by Shinichiro Kudo on 2021/07/23.
//

import Foundation

struct TitelForTextField {
    
    let titleString: String
    
    static func createTitles() -> [TitelForTextField] {
        
        let createArray = [
            TitelForTextField(titleString: "Xを数字で入力してください"),
            TitelForTextField(titleString: "Yを数字で入力してください"),
            TitelForTextField(titleString: "Widthを数字で入力してください"),
            TitelForTextField(titleString: "Heightを数字で入力してください")
        ]
        
        return createArray
    }

}
