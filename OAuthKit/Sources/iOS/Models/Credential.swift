//  Copyright © 2016 Atlassian. All rights reserved.

import Foundation

struct Credential {
  let accessToken: String
  let expirationDate: NSDate
  let scopes: [String]
  let expiresIn: Int
  let refreshToken: String
  let tokenType: String
}
