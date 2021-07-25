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
    
    private var presenter: SettingPresenterInput!
    func inject(presenter: SettingPresenterInput) {
        self.presenter = presenter
    }
    
    @objc func updateButtonTapped() {
        textFieldX.resignFirstResponder()
        textFieldY.resignFirstResponder()
        textFieldWidth.resignFirstResponder()
        textFieldHeight.resignFirstResponder()
        
        let parameters = InputParameters(textX: textFieldX.text,
                                                textY: textFieldY.text,
                                                textWidth: textFieldWidth.text,
                                                textHeight: textFieldHeight.text)
        
        self.presenter.input(parameters: parameters)
    }
    
    func alertError(message: String) {
        let alert = UIAlertController(title: "入力エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    

}

extension SettingViewController: SettingPresenterOutput {
    
    func dismiss(permission: Bool) {
        guard permission else {
            return
        }
        Router.backView(fromVC: self)
    }
    
    func getError(error: InputError) {
        self.alertError(message: error.errorDescription)
    }
    
}
