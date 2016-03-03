//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation
import OAuthKit

public class GetAuthenticatedUserAction: Action {
  private let accountStore: AccountStore
  public private(set) var outcome = Outcome<User>.Error(BitbucketKit.Error.GenericError)

  public init(accountStore: AccountStore) {
    self.accountStore = accountStore
    super.init()
  }

  override func run() {
    accountStore.getAuthenticatedAccount { account in
      guard let account = account else {
        self.outcome = .Error(BitbucketKit.Error.GenericError)
        self.finishedExecutingAction()
        return
      }
      self.runWithAuthenticatedAccount(account)
    }
  }

  func runWithAuthenticatedAccount(account: Account) {
    guard let url = NSURL(string: "https://api.bitbucket.org/2.0/user") else {
      return
    }
    let request = NSMutableURLRequest(URL: url)
    self.accountStore.authenticateURLRequest(request) { request in
      guard let request = request else {
        self.outcome = .Error(BitbucketKit.Error.GenericError)
        self.finishedExecutingAction()
        return
      }
      self.runWithAuthenticatedRequest(request, authenticatedAccont: account)
    }
  }

  func runWithAuthenticatedRequest(request: NSMutableURLRequest, authenticatedAccont: Account) {
    NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
      guard error == nil else {
        print("HTTP Error GETing authenitcated user.")
        self.outcome = .Error(BitbucketKit.Error.GenericError)
        self.finishedExecutingAction()
        return
      }
      guard let data = data else {
        print("HTTP GET for authenticated user did not return any data.")
        self.outcome = .Error(BitbucketKit.Error.GenericError)
        self.finishedExecutingAction()
        return
      }

      if let response = String(data: data, encoding: NSUTF8StringEncoding) {
        print("Response: \(response)")
      } else {
        print("Could not convert response data into UTF8 String from authenticated user GET.")
      }

      do {
        guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {
          self.outcome = .Error(BitbucketKit.Error.GenericError)
          self.finishedExecutingAction()
          return
        }
        guard let username = json["username"] as? String,
          displayName = json["display_name"] as? String,
          identifier = json["uuid"] as? String,
          links = json["links"] as? [String: AnyObject],
          avatar = links["avatar"] as? [String: AnyObject],
          avatarURLString = avatar["href"] as? String,
          avatarURL = NSURL(string: avatarURLString) else {
            self.outcome = .Error(BitbucketKit.Error.GenericError)
            self.finishedExecutingAction()
            return
        }
        let freshAccount = Account(identifier: identifier, username: username, displayName: displayName, avatarURL: avatarURL, credential: authenticatedAccont.credential)
        let user = User(username: freshAccount.username, displayName: freshAccount.displayName, avatarURL: freshAccount.avatarURL)
        self.outcome = .Success(user)
        self.finishedExecutingAction()
      } catch {
        self.outcome = .Error(BitbucketKit.Error.GenericError)
        self.finishedExecutingAction()
      }
    }.resume()
  }
}
