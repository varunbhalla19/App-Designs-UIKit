//
//  ViewController.swift
//  App Designs
//
//  Created by varunbhalla19 on 04/09/22.
//

import UIKit

class ViewController: UIViewController {

    lazy var movieController = TheatreViewController.init(nibName: nil, bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let customBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        customBackButton.tintColor = .white
        navigationItem.backBarButtonItem = customBackButton
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .seconds(2)) {
            self.moveTo()
        }
        
    }

    func moveTo() {
        self.navigationController?.pushViewController(movieController, animated: true)
    }

}

