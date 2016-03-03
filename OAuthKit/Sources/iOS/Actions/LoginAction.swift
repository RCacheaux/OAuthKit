//  Copyright © 2016 Atlassian. All rights reserved.

import UIKit

public class LoginAction: Action {
  let presentingViewController: UIViewController
  public internal(set) var credential: Credential?
  public internal(set) var account: Account?
  let accountStore: AccountStore

  public init(presentingViewController: UIViewController, accountStore: AccountStore) {
    self.presentingViewController = presentingViewController
    self.accountStore = accountStore
    super.init()
  }

  override func run() {
    let webLoginFlow = WebLoginFlow(onComplete: {
      self.credential = $0
      self.getUser(onComplete: { account in
        self.account = account
        dispatch_async(dispatch_get_main_queue()) {
          self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        self.finishedExecutingAction()
      })
    })
    dispatch_async(dispatch_get_main_queue()) {
      self.presentingViewController.presentViewController(webLoginFlow, animated: true, completion: nil)
    }
  }


  func getUser(onComplete onComplete: Account -> Void) {


    guard let url = NSURL(string: "https://api.bitbucket.org/2.0/user") else {
      return
    }
    let request = NSMutableURLRequest(URL: url)
    request.setValue("Bearer \(self.credential!.accessToken)", forHTTPHeaderField: "Authorization")

    NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
      guard error == nil else {
        print("HTTP Error GETing authenitcated user.")
        return
      }
      guard let data = data else {
        print("HTTP GET for authenticated user did not return any data.")
        return
      }

      if let response = String(data: data, encoding: NSUTF8StringEncoding) {
        print("Response: \(response)")
      } else {
        print("Could not convert response data into UTF8 String from authenticated user GET.")
      }

      do {
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        if let json = json as? [String: AnyObject] {
          if let
            username = json["username"] as? String,
            displayName = json["display_name"] as? String,
            identifier = json["uuid"] as? String,
            links = json["links"] as? [String: AnyObject],
            avatar = links["avatar"] as? [String: AnyObject],
            avatarURLString = avatar["href"] as? String,
            avatarURL = NSURL(string: avatarURLString) {
              let account = Account(identifier: identifier, username: username, displayName: displayName, avatarURL: avatarURL, credential: self.credential!)
              self.accountStore.saveAuthenticatedAccount(account) {
                onComplete(account)
              }
          }
        }
      } catch {
        // TODO: Handle this situation.
      }
    }.resume()

  }

}
