//
//  Router.swift
//  SampleCodeLayout
//
//  Created by Shinichiro Kudo on 2021/07/23.
//

import UIKit

final class Router {
    
    static let shared: Router = .init()
    private init() {}
       

    static func showPreview(window: UIWindow?) {
        
        let vc = PreviewViewController()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    private static func show(fromVC: UIViewController, nextVC: UIViewController) {
        if let nav = fromVC.navigationController {
            nav.pushViewController(nextVC, animated: true)
        } else {
            fromVC.present(nextVC, animated: true, completion: nil)
        }
    }
}
