import UIKit
import OAuthSwift

class entryViewController: UIViewController
{
    @IBOutlet weak var authorizeButton: UIButton!
    
    var oauthswift : OAuth2Swift! = nil
    
    var parameters: [String: AnyObject]!
    var headers : [String: String]!
    
    override func viewDidLoad()
    {
        oauthswift = OAuth2Swift(
            consumerKey:    "227PY3",
            consumerSecret: "45f55ccb22b53f34f3f5f84200e67df6",
            authorizeUrl:   "https://www.fitbit.com/oauth2/authorize",
            accessTokenUrl: "https://api.fitbit.com/oauth2/token",
            responseType:   "code"
        )
    }
    @IBAction func authorizeButtonTapped(sender: AnyObject)
    {
        
        oauthswift.accessTokenBasicAuthentification = true
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "BHSFitbitPE://com.bhsfitbit.pe")!, scope: "activity  profile social", state: state, success: {
            credential, response, parameters in
            
            self.parameters = parameters
            
            var headers: [String:String]? = nil
            if self.oauthswift.accessTokenBasicAuthentification {
                let authentification = "227PY3:45f55ccb22b53f34f3f5f84200e67df6".dataUsingEncoding(NSUTF8StringEncoding)
                if let base64Encoded = authentification?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                {
                    headers = ["Authorization": "Basic \(base64Encoded)"]
                }
            }
            
            self.performSegueWithIdentifier("segue1", sender: self)
            
            }, failure: { error in
                print(error.localizedDescription)
        })
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segue1"
        {
            let dvc = segue.destinationViewController as! UINavigationController
            let vc = dvc.viewControllers.first as! ViewController
            vc.oauthswift = self.oauthswift
            vc.parameters = self.parameters
            vc.headers = self.headers
        }
        
    }
}