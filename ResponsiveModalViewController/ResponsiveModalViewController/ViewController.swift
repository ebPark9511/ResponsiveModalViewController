//
//  ViewController.swift
//  ResponsiveModalViewController
//
//  Created by 박은비 on 2020/11/18.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func didTapButton(_ sender: Any) {
        let vc = ResponsiveModalViewController(withView: ContentView.instantiate())
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
}
 
