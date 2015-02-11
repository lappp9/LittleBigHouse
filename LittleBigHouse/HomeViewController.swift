
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var addressButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressButton.layer.cornerRadius = 4
        addressButton.backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        addressButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addressButton.layer.shadowColor = UIColor.lightGrayColor().CGColor
        addressButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        addressButton.layer.shadowOpacity = 1.0
    }

    @IBAction func addressButtonWasTapped(sender: AnyObject) {
    
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
