//
//  ViewController.swift
//  SampleCodeLayout
//
//  Created by Shinichiro Kudo on 2021/07/23.
//

import UIKit

class PreviewViewController: UIViewController {
    
    private var sampleX = NSLayoutConstraint()
    private var sampleY = NSLayoutConstraint()
    private var sampleWidth = NSLayoutConstraint()
    private var sampleHeight = NSLayoutConstraint()
    
    private var itemContsraint: ObjectConstraint = ObjectConstraint.createDefaultConstraint()
    
    private let itemView: UIView = {
        let itemView = UIView()
        itemView.backgroundColor = .systemGray
        return itemView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "プレビュー画面"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "設定",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSetting))
        
        itemView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(itemView)
        feachNewConstraint(constraint: self.itemContsraint)
        
        view.backgroundColor = .systemBackground
    }
    
    @objc private func didTapSetting() {
        let settingVC = SettingViewController()
        settingVC.delegate = self
        
        self.present(settingVC, animated: true, completion: nil)
    }
    
    private func feachNewConstraint(constraint: ObjectConstraint) {
        sampleX =  itemView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(constraint.topAnchorX))
        sampleY = itemView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(constraint.leftAnchorY))
        sampleWidth = itemView.widthAnchor.constraint(equalToConstant: CGFloat(constraint.widthAnchorInt))
        sampleHeight = itemView.heightAnchor.constraint(equalToConstant: CGFloat(constraint.heightAnchorInt))
        
        sampleX.isActive = true
        sampleY.isActive = true
        sampleWidth.isActive = true
        sampleHeight.isActive = true
        
        self.view.layoutIfNeeded()
    }
    
    private func feachChangeConstraint() {
        itemView.removeConstraint(sampleX)
        itemView.removeConstraint(sampleY)
        itemView.removeConstraint(sampleWidth)
        itemView.removeConstraint(sampleHeight)
        self.loadView()
        self.viewDidLoad()
    }


}

extension PreviewViewController: ToPassDataProtocol {
    
    func tappedUpdateButton(data: ObjectConstraint) {
        print("プロトコルから受け取ったdata: \(data)")
        itemContsraint = data
        feachChangeConstraint()
    }
    
}
