//  Copyright © 2016 Atlassian. All rights reserved.

import Foundation

public class AccountStore {
  private var store: [Account] = []
  private let mutationQueue = dispatch_queue_create("com.atlassian.oauthkit.accountStore.mutation", DISPATCH_QUEUE_SERIAL)

  public init() {}

  func saveAuthenticatedAccount(account: Account, onComplete: Void -> Void) {
    dispatch_async(mutationQueue) {
      self.unsafeSaveAuthenticatedAccount(account)
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
        onComplete()
      }
    }
  }

  private func unsafeSaveAuthenticatedAccount(account: Account) {
    store = [account]
  }

  public func getAuthenticatedAccount(onComplete: Account? -> Void) {
    dispatch_async(mutationQueue) {
      self.unsafeGetAuthenticatedAccount(onComplete)
    }
  }

  private func unsafeGetAuthenticatedAccount(onComplete: Account? -> Void) {
    if let account = store.first {
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
        onComplete(account)
      }
    } else {
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
        onComplete(nil)
      }
    }
  }

  public func authenticateURLRequest(request: NSMutableURLRequest, onComplete: NSMutableURLRequest? -> Void) {
    dispatch_async(mutationQueue) {
      self.unsafeAuthenticateURLRequest(request, onComplete: onComplete)
    }
  }

  private func unsafeAuthenticateURLRequest(request: NSMutableURLRequest, onComplete: NSMutableURLRequest? -> Void) {
    if let account = store.first {
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
        request.setValue("Bearer \(account.credential.accessToken)", forHTTPHeaderField: "Authorization")
        onComplete(request)
      }
    } else {
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
        onComplete(nil)
      }
    }
  }
}
