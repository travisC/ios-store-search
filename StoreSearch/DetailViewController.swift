//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Travis Cunningham on 8/5/17.
//  Copyright © 2017 Travis Cunningham. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController)
        -> UIPresentationController? {
            return DimmingPresentationController(
                presentedViewController: presented, presenting: presenting)
    }
}
