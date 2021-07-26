//
//  TextFieldExtention.swift
//  SampleCodeLayout
//
//  Created by Shinichiro Kudo on 2021/07/23.
//

import UIKit

struct TextFieldLayerParameters {
    var cornerRadius: CGFloat = 12
    var borderWidth: CGFloat = 1
    var borderColor: CGColor = UIColor.lightGray.cgColor
}

struct TitelForTextField {
    let titleString: String
    static func createTitles() -> [TitelForTextField] {
        let createArray = [
            TitelForTextField(titleString: "Xを数字で入力"),
            TitelForTextField(titleString: "Yを数字で入力"),
            TitelForTextField(titleString: "Widthを数字で入力"),
            TitelForTextField(titleString: "Heightを数字で入力")
        ]
        return createArray
    }
}

extension UITextField {
    
    func setTextFieldParameters(parameter: TextFieldLayerParameters = .init()) {
        
        self.layer.cornerRadius = parameter.cornerRadius
        self.layer.borderWidth = parameter.borderWidth
        self.layer.borderColor = parameter.borderColor
        
        self.backgroundColor = .white
        self.keyboardType = .numberPad
        self.returnKeyType = .default
        self.textAlignment = .center
    }
    
}

// NumberPadに閉じるボタンつける
extension UITextField {
    func addcloseToolbar(onClose: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onClose = onClose ?? (target: self, action: #selector(closeButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "閉じる", style: .plain, target: onClose.target, action: onClose.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }
    @objc func closeButtonTapped() { self.resignFirstResponder() }
}
