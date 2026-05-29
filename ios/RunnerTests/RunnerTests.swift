import Flutter
import UIKit
import XCTest

class RunnerTests: XCTestCase {

  func testExample() {
    // If you add code to the Runner application, consider adding tests here.
    // See https://developer.apple.com/documentation/xctest for more information about using XCTest.
  }

  override func setUp() {
    super.setUp()
    // Automatically dismiss any system permission dialogs (e.g. VPN, Location,
    // Local Network) that appear during integration test runs by tapping the
    // first button labelled "Allow", "OK", or "Continue".
    addUIInterruptionMonitor(withDescription: "System permission alert") { alert in
      let allowLabels = ["Allow", "Allow While Using App", "Allow Once", "OK", "Continue"]
      for label in allowLabels {
        if alert.buttons[label].exists {
          alert.buttons[label].tap()
          return true
        }
      }
      return false
    }
  }

}
