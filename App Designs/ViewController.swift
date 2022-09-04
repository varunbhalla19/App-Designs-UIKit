//
//  ViewController.swift
//  App Designs
//
//  Created by varunbhalla19 on 04/09/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let customBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        customBackButton.tintColor = .white
        navigationItem.backBarButtonItem = customBackButton
        
    }


}

