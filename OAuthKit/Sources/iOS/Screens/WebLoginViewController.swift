//  Copyright © 2016 Atlassian. All rights reserved.

import UIKit

class WebLoginViewController: UIViewController {
  let clientSecret: String
  let clientID: String
  var rootView: WebLoginRootView {
    return view as! WebLoginRootView
  }

  init(clientSecret: String, clientID: String) {
    self.clientSecret = clientSecret
    self.clientID = clientID
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("WebLoginViewController does not support initialization with NSCoding.")
  }

  override func loadView() {
    view = WebLoginRootView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let url = NSURL(string: "https://bitbucket.org/site/oauth2/authorize?client_id=\(clientID)&response_type=code") else {
      return
    }
    let request = NSURLRequest(URL: url)

    rootView.onAuthCodeRetrieved = { [weak self] authCode in
      self?.getAccessTokenWithAuthCode(authCode)
    }

    rootView.loadRequest(request)
  }

  func getAccessTokenWithAuthCode(authCode: String) {

    guard let url = NSURL(string: "https://bitbucket.org/site/oauth2/access_token?grant_type=authorization_code&code=\(authCode)&redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb") else {
      return
    }
    print("POSTing \(url.absoluteString)")
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "POST"

    let basicAuthCredentials = "\(clientID):\(clientSecret)"
    if let basicAuthCredentialsData = basicAuthCredentials.dataUsingEncoding(NSUTF8StringEncoding) {
      let base64EncodedCredentials = basicAuthCredentialsData.base64EncodedDataWithOptions([])
      let basicAuthHeaderValue = "Basic \(base64EncodedCredentials)"
      request.setValue(basicAuthHeaderValue, forHTTPHeaderField: "Authorization")
    } else {
      print("Could not create Basic Auth HTTP header before POSTing for access token.")
      return
    }
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
      guard error == nil else {
        print("HTTP Error POSTing for access token.")
        return
      }
      guard let data = data else {
        print("HTTP POST for access token did not return any data.")
        return
      }

      if let response = String(data: data, encoding: NSUTF8StringEncoding) {
        print("Response: \(response)")
      } else {
        print("Could not convert response data into UTF8 String from access token POST.")
      }
    }.resume()

  }

}
