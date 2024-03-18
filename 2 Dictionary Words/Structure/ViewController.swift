//
//  ViewController.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/2/24.
//

import UIKit

class ViewController: UIViewController {

    let introView = IntroView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.constrain(introView)
        
        self.overrideUserInterfaceStyle = .light
        
        introView.viewController = self
        
        
    }

    func startGame() {
        let vc = GameplayViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

