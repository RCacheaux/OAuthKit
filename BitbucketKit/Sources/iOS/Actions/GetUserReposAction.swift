//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation
import OAuthKit

public class GetUserReposAction: Action {
  public private(set) var outcome = Outcome<[Repo]>.Error(BitbucketKit.Error.GenericError)
  private let user: User
  private let accountStore: AccountStore

  public init(user: User, accountStore: AccountStore) {
    self.user = user
    self.accountStore = accountStore
    super.init()
  }

  override func run() {
    guard let url = NSURL(string: "https://api.bitbucket.org/2.0/repositories/\(user.username)") else {
      outcome = .Error(BitbucketKit.Error.GenericError)
      finishedExecutingAction()
      return
    }
    let request = NSMutableURLRequest(URL: url)
    accountStore.authenticateURLRequest(request) { request in
      guard let request = request else {
        self.outcome = .Error(BitbucketKit.Error.GenericError)
        self.finishedExecutingAction()
        return
      }
      self.runWithAuthenticatedRequest(request)
    }
  }

  private func runWithAuthenticatedRequest(request: NSMutableURLRequest) {
    NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
      guard error == nil else {
        print("HTTP Error GETing user repos.")
        self.outcome = .Error(BitbucketKit.Error.GenericError)
        self.finishedExecutingAction()
        return
      }
      guard let data = data else {
        print("HTTP GET for user repos did not return any data.")
        self.outcome = .Error(BitbucketKit.Error.GenericError)
        self.finishedExecutingAction()
        return
      }
      if let response = String(data: data, encoding: NSUTF8StringEncoding) {
        print("Response: \(response)")
      } else {
        print("Could not convert response data into UTF8 String from user repos GET.")
      }
      do {
        guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {
          self.outcome = .Error(BitbucketKit.Error.GenericError)
          self.finishedExecutingAction()
          return
        }
        guard let values = json["values"] as? [[String: AnyObject]] else {
            self.outcome = .Error(BitbucketKit.Error.GenericError)
            self.finishedExecutingAction()
            return
        }
        let repos = values.map { (json: [String: AnyObject]) -> Repo in
          guard let name = json["name"] as? String,
            description = json["description"] as? String,
            ownerJSON = json["owner"] as? [String: AnyObject] else {
              return Repo(name: "", description: "", owner: User(username: "", displayName: "", avatarURL: NSURL()))
          }
          guard let username = ownerJSON["username"] as? String,
            displayName = ownerJSON["display_name"] as? String,
            links = ownerJSON["links"] as? [String: AnyObject],
            avatar = links["avatar"] as? [String: AnyObject],
            avatarHRef = avatar["href"] as? String,
            avatarURL = NSURL(string: avatarHRef) else {
              return Repo(name: "", description: "", owner: User(username: "", displayName: "", avatarURL: NSURL()))
          }
          let owner = User(username: username, displayName: displayName, avatarURL: avatarURL)
          return Repo(name: name, description: description, owner: owner)
        }
        self.outcome = .Success(repos)
        self.finishedExecutingAction()
      } catch {
        self.outcome = .Error(BitbucketKit.Error.GenericError)
        self.finishedExecutingAction()
      }
    }.resume()
  }
}
