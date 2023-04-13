//
//  ViewController.swift
//  MZToast
//
//  Created by macmini_zl on 2023/4/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func showCenterToast(_ sender: Any) {
        MZToast.showToast("I am a center toast")
    }
    
    @IBAction func showBottomToast(_ sender: Any) {
        MZToast.showToast("I am a bottom toast", position: .Bottom) { auto in
            NSLog("Toast dismiss \(auto ? "auto" : "cover")")
        }
    }
    
    @IBAction func showLoading(_ sender: Any) {
        MZToast.showLoading("I am a loading view")
        
        self.perform(#selector(autoHiddenLoading), with: nil, afterDelay: 2.0)
    }
    
    @objc func autoHiddenLoading() {
        MZToast.hideLoading()
    }
    
    @IBAction func showLoadingWithoutMask(_ sender: Any) {
        MZToast.showLoading(showMask: false)
    }
    
    @IBAction func hideLoading(_ sender: Any) {
        MZToast.hideLoading()
    }
}

