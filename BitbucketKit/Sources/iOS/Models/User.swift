//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

public struct User {
  public let username: String
  public let displayName: String
  public let avatarURL: NSURL

  public init(username: String, displayName: String, avatarURL: NSURL) {
    self.username = username
    self.displayName = displayName
    self.avatarURL = avatarURL
  }
}
