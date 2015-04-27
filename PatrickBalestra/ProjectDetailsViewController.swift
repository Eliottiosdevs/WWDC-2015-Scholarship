//
//  ProjectDetailsViewController.swift
//  PatrickBalestra
//
//  Created by Patrick Balestra on 20/04/15.
//  Copyright (c) 2015 Patrick Balestra. All rights reserved.
//

import UIKit
import StoreKit

class ProjectDetailsViewController: UIViewController, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var skillsView: SkillsView!
    @IBOutlet weak var appTextView: UITextView!
    @IBOutlet weak var firstScreenshot: UIImageView!
    @IBOutlet weak var secondScreenshot: UIImageView!
    @IBOutlet weak var thirdScreenshot: UIImageView!
    
    @IBOutlet weak var viewInAppStore: LinkButton!
    @IBOutlet weak var viewWebsite: LinkButton!
    
    var project: Project?
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 20)!]
        
        self.title = self.project?.title
        self.iconImageView.image = UIImage(named: self.project?.iconName ?? "")
        self.titleLabel.text = self.project?.title
        self.descriptionLabel.text = self.project?.subtitle
        self.dateLabel.text = self.project?.date
        self.appTextView.text = self.project?.description
        self.firstScreenshot.image = UIImage(named: self.project!.screenshotNames[0])
        self.secondScreenshot.image = UIImage(named: self.project!.screenshotNames[1])
        self.thirdScreenshot.image = UIImage(named: self.project!.screenshotNames[2])
        self.skillsView.skills = self.project!.skills
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.navigationController?.navigationBar.barTintColor = self.project?.appColor
        })
        
        self.iconImageView.layer.shadowColor = UIColor.blackColor().CGColor
        self.iconImageView.layer.shadowOffset = CGSizeMake(1, 1)
        self.iconImageView.layer.shadowOpacity = 0.25
        
        self.viewInAppStore.backgroundColor = self.project?.appColor
        self.viewInAppStore.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        self.viewWebsite.backgroundColor = self.project?.appColor
        if self.project?.title == "Notes for Watch" {
            self.viewWebsite.setTitleColor(UIColor.blackColor(), forState: .Normal)
            self.viewInAppStore.setTitleColor(UIColor.blackColor(), forState: .Normal)
        } else {
            self.viewWebsite.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.viewInAppStore.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.202, green:0.808, blue:0.459, alpha:1)
        })
    }
    
    // MARK: IBActions
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func viewInAppStore(sender: AnyObject) {
        self.openProjectInAppStore(self.project!.iTunesID)
    }
    
    @IBAction func viewWebsite(sender: AnyObject) {
        let URL = self.project!.websiteLink
        UIApplication.sharedApplication().openURL(URL)
    }
    
    // MARK: Methods
    
    func openProjectInAppStore(appID: String) {
        var viewController: SKStoreProductViewController = SKStoreProductViewController()
        var parameters = [
            SKStoreProductParameterITunesItemIdentifier : appID,
        ]
        viewController.delegate = self
        viewController.loadProductWithParameters(parameters, completionBlock: { (completed, error) -> Void in
            println(error)
        })
        self.presentViewController(viewController, animated: true) { () -> Void in }
    }
    
    // MARK: SKStoreProductViewControllerDelegate
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }

}