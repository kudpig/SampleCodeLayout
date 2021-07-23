//
//  ViewController.swift
//  SampleCodeLayout
//
//  Created by Shinichiro Kudo on 2021/07/23.
//

import UIKit

class PreviewViewController: UIViewController {
    
    var sampleX = NSLayoutConstraint()
    var sampleY = NSLayoutConstraint()
    var sampleWidth = NSLayoutConstraint()
    var sampleHeight = NSLayoutConstraint()
    
    var moveObjectContsraint = ObjectConstraint(topAnchorX: 50, topAnchorY: 50, widthAnchorInt: 50, heightAnchorInt: 50)
    
    private let moveView: UIView = {
        let moveView = UIView()
        moveView.backgroundColor = .systemGray
        return moveView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "プレビュー画面"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "設定",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSetting))
        
        moveView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(moveView)
        feachNewConstraint(constraint: self.moveObjectContsraint)
        
        view.backgroundColor = .systemBackground
    }
    
    @objc private func didTapSetting() {
        let settingVC = SettingViewController()
        
        self.present(settingVC, animated: true, completion: nil)
    }
    
    private func feachNewConstraint(constraint: ObjectConstraint) {
        sampleX =  moveView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(constraint.topAnchorX))
        sampleY = moveView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(constraint.topAnchorY))
        sampleWidth = moveView.widthAnchor.constraint(equalToConstant: CGFloat(constraint.widthAnchorInt))
        sampleHeight = moveView.heightAnchor.constraint(equalToConstant: CGFloat(constraint.heightAnchorInt))
        
        sampleX.isActive = true
        sampleY.isActive = true
        sampleWidth.isActive = true
        sampleHeight.isActive = true
        
        self.view.layoutIfNeeded()
    }


}

