//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

public struct Repo {
  public let name: String
  public let description: String
  public let owner: User

  public init(name: String, description: String, owner: User) {
    self.name = name
    self.description = description
    self.owner = owner
  }
}
