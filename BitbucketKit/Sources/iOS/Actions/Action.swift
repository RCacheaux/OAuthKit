//  Copyright © 2016 Atlassian. All rights reserved.

import Foundation

public class Action: NSOperation {
  private var _executing = false
  private var _finished = false

  override private(set) public var executing: Bool {
    get {
      return _executing
    }
    set {
      willChangeValueForKey("isExecuting")
      _executing = newValue
      didChangeValueForKey("isExecuting")
    }
  }

  override private(set) public var finished: Bool {
    get {
      return _finished
    }
    set {
      willChangeValueForKey("isFinished")
      _finished = newValue
      didChangeValueForKey("isFinished")
    }
  }

  override public var asynchronous: Bool {
    return true
  }

  override public func start() {
    if cancelled {
      finished = true
      return
    }

    executing = true
    autoreleasepool {
      run()
    }
  }

  func run() {
    preconditionFailure("Action.run() abstract method must be overridden.")
  }

  func finishedExecutingAction() {
    executing = false
    finished = true
  }
}
