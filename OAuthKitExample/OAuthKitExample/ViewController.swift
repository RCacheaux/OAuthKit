//
//  ViewController.swift
//  OAuthKitExample
//
//  Created by Rene Cacheaux on 3/2/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import UIKit
import OAuthKit

class ViewController: UIViewController {
  var loginAction: LoginAction?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    loginAction = LoginAction(presentingViewController: self)
    loginAction?.start()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

