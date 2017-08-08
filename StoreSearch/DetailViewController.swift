//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Travis Cunningham on 8/5/17.
//  Copyright © 2017 Travis Cunningham. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    var searchResult: SearchResult! {
        didSet {
            if isViewLoaded {
                updateUI()
            }
        }
    }
    
    var downloadTask: URLSessionDownloadTask?
    
    var isPopUp = false
    
    @IBAction func close() {
        dismissAnimationStyle = .slide
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear

        // Do any additional setup after loading the view.
        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        popupView.layer.cornerRadius = 10
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        if searchResult != nil {
            updateUI()
        }
        
        if isPopUp {
            let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                           action: #selector(close))
            gestureRecognizer.cancelsTouchesInView = false
            gestureRecognizer.delegate = self
            view.addGestureRecognizer(gestureRecognizer)
            view.backgroundColor = UIColor.clear
        } else {
            view.backgroundColor = UIColor(patternImage:
                UIImage(named: "LandscapeBackground")!)
            popupView.isHidden = true
            
            if let displayName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
                title = displayName
            }
        }
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
    
    func updateUI() {
        nameLabel.text = searchResult.name
        if searchResult.artistName.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = searchResult.artistName
        }
        kindLabel.text = searchResult.kindForDisplay()
        genreLabel.text = searchResult.genre
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        let priceText: String
        if searchResult.price == 0 {
            priceText = "Free"
        } else if let text = formatter.string(
            from: searchResult.price as NSNumber) {
            priceText = text
        } else {
            priceText = ""
        }
        priceButton.setTitle(priceText, for: .normal)
        
        if let largeURL = URL(string: searchResult.artworkLargeURL) {
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
        
        popupView.isHidden = false
    }
    
    deinit {
        //print("deinit \(self)")
        downloadTask?.cancel()
    }
    
    enum AnimationStyle {
        case slide
        case fade
    }
    var dismissAnimationStyle = AnimationStyle.fade
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMenu" {
            let controller = segue.destination as! MenuViewController
            controller.delegate = self
        }
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
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return BounceAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            switch dismissAnimationStyle {
            case .slide:
                return SlideOutAnimationController()
            case .fade:
                return FadeOutAnimationController()
            }
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}

extension DetailViewController: MenuViewControllerDelegate {
    func menuViewControllerSendSupportEmail(_: MenuViewController) {
        dismiss(animated: true) {
            if MFMailComposeViewController.canSendMail() {
                let controller = MFMailComposeViewController()
                controller.setSubject(NSLocalizedString("Support Request",
                                                        comment: "Send Help"))
                controller.setToRecipients(["info@travis-cunningham.com"])
                self.present(controller, animated: true, completion: nil)
                controller.mailComposeDelegate = self
                controller.modalPresentationStyle = .formSheet
            }
        }
    }
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
