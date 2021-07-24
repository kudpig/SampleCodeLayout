//
//  SettingViewController.swift
//  SampleCodeLayout
//
//  Created by Shinichiro Kudo on 2021/07/23.
//

import UIKit

class SettingViewController: UIViewController {
    
    private let titles = TitelForTextField.createTitles()
    private lazy var textFields = [textFieldX, textFieldY, textFieldWidth, textFieldHeight]
    
    weak var delegate: ToPassDataProtocol?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "設置位置を入力してください"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let textFieldX = UITextField()
    private let textFieldY = UITextField()
    private let textFieldWidth = UITextField()
    private let textFieldHeight = UITextField()
    
    private  let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("更新する", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupFrame(self: stackView,
                   setX: 50,
                   setY: 30,
                   setWidth: view.frame.size.width-100,
                   setHeight: view.frame.size.height/2)
        setupStackViewContents()
        view.addSubview(stackView)
    }
    
    private func setupFrame(self: UIView, setX: CGFloat, setY: CGFloat, setWidth: CGFloat, setHeight: CGFloat) {
        self.frame = CGRect(x: setX,
                            y: setY,
                            width: setWidth,
                            height: setHeight)
    }
    
    private func setupStackViewContents() {
        
        self.stackView.addArrangedSubview(titleLabel)
        
        for (index, textfield) in textFields.enumerated() {
            textfield.setTextFieldParameters()
            textfield.addcloseToolbar()
            
            textfield.placeholder = titles[index].titleString
            self.stackView.addArrangedSubview(textfield)
        }
        
        self.stackView.addArrangedSubview(updateButton)
    }
    
    @objc private func updateButtonTapped() {
        print("tap")
        textFieldX.resignFirstResponder()
        textFieldY.resignFirstResponder()
        textFieldWidth.resignFirstResponder()
        textFieldHeight.resignFirstResponder()
        
        guard let textX = textFieldX.text,
              let textY = textFieldY.text,
              let textWidth = textFieldWidth.text,
              let textHeight = textFieldHeight.text,
              !textX.isEmpty,
              !textY.isEmpty,
              !textWidth.isEmpty,
              !textHeight.isEmpty else {
            // エラーハンドリング
            print("入力されていない項目があります")
            return
        }
        
        guard let intX = NumberFormatter().number(from: textX) as? Int,
              let intY = NumberFormatter().number(from: textY) as? Int,
              let intWidth = NumberFormatter().number(from: textWidth) as? Int,
              let intHeight = NumberFormatter().number(from: textHeight) as? Int else {
            // エラーハンドリング
            print("数字が入力されていません")
            return
        }
        
        let inputConstraint = ObjectConstraint(topAnchorX: intX,
                                               leftAnchorY: intY,
                                               widthAnchorInt: intWidth,
                                               heightAnchorInt: intHeight)
        
        delegate?.tappedUpdateButton(data: inputConstraint)
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
