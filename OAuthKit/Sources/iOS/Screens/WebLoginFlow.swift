//  Copyright © 2016 Atlassian. All rights reserved.

import UIKit

class WebLoginFlow: UINavigationController {

  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    initialSetup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  func initialSetup() {
    let rootViewController = WebLoginViewController(clientSecret: "FvJZbXZ8xb35hfFj2s764sE8E3rLafuD", clientID: "HjqbXY9cwe5bApa9xs")
    rootViewController.navigationItem.title = "Login"
    viewControllers = [rootViewController]
  }
}
