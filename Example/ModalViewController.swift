//
//  ModalViewController.swift
//  Example
//
//  Created by xiaopin on 2018/4/18.
//

import UIKit

class ModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
