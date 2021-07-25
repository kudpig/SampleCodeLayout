//
//  Router.swift
//  SampleCodeLayout
//
//  Created by Shinichiro Kudo on 2021/07/23.
//

import UIKit

final class Router {
    
    private init() {}
       
    static func showPreview(window: UIWindow?) {
        let vc = PreviewViewController()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    static func showSetting(fromVC: UIViewController) {
        let vc = SettingViewController()
        vc.delegate = fromVC as? ToPassDataProtocol
        let presenter = Presenter(outputSetting: vc, outputPreview: fromVC as! PreviewPresenterOutput)
        vc.inject(presenter: presenter)
        show(fromVC: fromVC, nextVC: vc)
    }
    
    static func backView(fromVC: UIViewController) {
        let vc = fromVC
        vc.navigationController?.popViewController(animated: true)
    }

    private static func show(fromVC: UIViewController, nextVC: UIViewController) {
        if let nav = fromVC.navigationController {
            nav.pushViewController(nextVC, animated: true)
        } else {
            fromVC.present(nextVC, animated: true, completion: nil)
        }
    }
    
    private static func back(fromVC: UIViewController) {
        if fromVC.navigationController == nil {
            fromVC.navigationController?.popViewController(animated: true)
        } else {
            fromVC.dismiss(animated: true, completion: nil)
        }
    }
}
