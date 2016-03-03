//  Copyright © 2016 Atlassian. All rights reserved.

import Foundation

public enum Outcome<T> {
  case Success(T)
  case Error(ErrorType)
  case Cancelled
}
