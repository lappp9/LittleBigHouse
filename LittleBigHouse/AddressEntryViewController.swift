//
//  AddressEntryViewController.swift
//  LittleBigHouse
//
//  Created by Luke Parham on 2/11/15.
//  Copyright (c) 2015 Luke Parham. All rights reserved.
//

import UIKit

class AddressEntryViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.layer.cornerRadius = 4
        nextButton.backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        nextButton.layer.shadowColor = UIColor.lightGrayColor().CGColor
        nextButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        nextButton.layer.shadowOpacity = 1.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
