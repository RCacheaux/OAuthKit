//  Copyright © 2016 Atlassian. All rights reserved.

import Foundation

public struct Credential {
  public let accessToken: String
  public let scopes: [String]
  public let expiresIn: Int
  public let refreshToken: String
  public let tokenType: String

  public init(accessToken: String, scopes: [String], expiresIn: Int, refreshToken: String, tokenType: String) {
    self.accessToken = accessToken
    self.scopes = scopes
    self.expiresIn = expiresIn
    self.refreshToken = refreshToken
    self.tokenType = tokenType
  }
}
