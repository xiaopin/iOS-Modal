//
//  ViewController.swift
//  Example
//
//  Created by xiaopin on 2018/4/18.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var size: CGSize
        var configuration = ModalConfiguration.default
        configuration.isEnableBackgroundAnimation = false
        switch indexPath.row {
        case 0:
            configuration.direction = .top
            size = CGSize(width: UIScreen.main.bounds.width, height: 300)
        case 1:
            configuration.direction = .right
            size = CGSize(width: 200.0, height: UIScreen.main.bounds.height)
        case 2:
            configuration.direction = .bottom
            configuration.isEnableBackgroundAnimation = true
            size = CGSize(width: UIScreen.main.bounds.width, height: 300)
        case 3:
            configuration.direction = .left
            size = CGSize(width: 200.0, height: UIScreen.main.bounds.height)
        case 4:
            configuration.direction = .center
            size = CGSize(width: 200.0, height: 300.0)
        default:
            return
        }
        
        // Use for UIViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ModalViewController")
        presentModalViewController(vc, contentSize: size, configuration: configuration, completion: nil)
        
        
//        // Use for UIView
//        configuration.isDismissModal = false
//        let modalView = UIView()
//        modalView.backgroundColor = UIColor.cyan
//        presentModalView(modalView, contentSize: size, configuration: configuration, completion: nil)
//        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
//            self.presentedViewController?.dismiss(animated: true, completion: nil)
//        }
    }


}

