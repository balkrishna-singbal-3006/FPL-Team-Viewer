// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
    func popBack()
    func performAction(_ action: Actionable)
}

public extension Coordinator {
    /**
     Pops the view controller from the navigation stack.
     */
    public func popBack() {
        self.navigationController.popViewController(animated: true)
    }
    
    public func performAction(_ action: Actionable) { }
}

public protocol Actionable { }
