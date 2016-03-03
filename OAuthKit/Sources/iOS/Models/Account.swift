//  Copyright © 2016 Atlassian. All rights reserved.

import Foundation

public struct Account {
  public let identifier: String
  public let username: String
  public let displayName: String
  public let avatarURL: NSURL
  public let credential: Credential

  public init(identifier: String, username: String, displayName: String, avatarURL: NSURL, credential: Credential) {
    self.identifier = identifier
    self.username = username
    self.displayName = displayName
    self.avatarURL = avatarURL
    self.credential = credential
  }
}
