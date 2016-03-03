//  Copyright © 2016 Atlassian. All rights reserved.

import UIKit

public class LoginAction: Action {
  let presentingViewController: UIViewController

  public init(presentingViewController: UIViewController) {
    self.presentingViewController = presentingViewController
    super.init()
  }

  override func run() {
    let webLoginFlow = WebLoginFlow()
    presentingViewController.presentViewController(webLoginFlow, animated: true, completion: nil)
  }

}
