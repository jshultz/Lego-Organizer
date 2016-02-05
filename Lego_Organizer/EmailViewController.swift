import Foundation
import UIKit
import MessageUI

class MailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var emailContents: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailContents.layer.borderColor = UIColor.blackColor().CGColor;
        emailContents.layer.borderWidth = 1.5
        emailContents.layer.cornerRadius = 5.0
        emailContents.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue:0, alpha: 1.0 ).CGColor;
        
    }
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        var emailBody = emailContents.text
        
        if (emailBody != nil) {
            
        } else {
            emailBody = "No contents were entered"
        }
        
        mailComposerVC.setToRecipients(["jasshultz@gmail.com"])
        mailComposerVC.setSubject("Email from Lego Organizer App")
        mailComposerVC.setMessageBody("\(emailBody)", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}