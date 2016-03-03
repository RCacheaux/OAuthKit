//  Copyright © 2016 Atlassian. All rights reserved.

import UIKit

class WebLoginFlow: UINavigationController {
  var onComplete: Credential -> Void

  convenience init(onComplete: Credential -> Void) {
    self.init(nibName: nil, bundle: nil, onComplete: onComplete)
  }

  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, onComplete: Credential -> Void) {
    self.onComplete = onComplete
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    initialSetup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("WebLoginFlow does not support initialization with NSCoding.")
  }

  func initialSetup() {
    let rootViewController = WebLoginViewController(clientSecret: "FvJZbXZ8xb35hfFj2s764sE8E3rLafuD", clientID: "HjqbXY9cwe5bApa9xs", onComplete: onComplete)
    rootViewController.navigationItem.title = "Login"
    viewControllers = [rootViewController]
  }
}
