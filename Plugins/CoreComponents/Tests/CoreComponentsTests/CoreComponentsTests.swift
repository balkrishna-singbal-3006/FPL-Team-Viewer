import XCTest
import UIKit

@testable import CoreComponents // Replace with your actual module name

final class CoordinatorTests: XCTestCase {
    
    private var sut: TestCoordinator!
    private var mockNavigationController: SpyNavigationController!
    
    override func setUp() {
        super.setUp()
        // Initialize our spy navigation controller and system under test (sut)
        mockNavigationController = SpyNavigationController()
        sut = TestCoordinator(navigationController: mockNavigationController)
    }
    
    override func tearDown() {
        sut = nil
        mockNavigationController = nil
        super.tearDown()
    }
    
    // MARK: - Tests for popBack()
    
    @MainActor
    func test_popBack_callsPopViewControllerOnNavigationController() {
        // Act
        sut.popBack()
        
        // Assert
        XCTAssertTrue(mockNavigationController.popViewControllerCalled, "Expected popViewController(animated:) to be called.")
        XCTAssertTrue(mockNavigationController.popViewControllerAnimatedFlag, "Expected popViewController to be triggered with animation set to true.")
    }
    
    // MARK: - Tests for performAction()
    @MainActor
    func test_performAction_doesNotCrashOrThrow() {
        // Arrange
        let mockAction = MockAction()
        
        // Act & Assert
        // Since the protocol extension provides an empty default body,
        // we assert it handles any action cleanly without side effects.
        XCTAssertNoThrow(sut.performAction(mockAction), "performAction should gracefully handle actions with its default empty implementation.")
    }
}

// MARK: - Test Spies & Mocks

/// A spy implementation of UINavigationController to track layout stack transitions.
private final class SpyNavigationController: UINavigationController {
    var popViewControllerCalled = false
    var popViewControllerAnimatedFlag = false
    
    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCalled = true
        popViewControllerAnimatedFlag = animated
        // Return a dummy controller to mimic UIKit's native behavior safely
        return UIViewController()
    }
}

/// A concrete test double conforming to Coordinator to expose the default extension behaviors.
private final class TestCoordinator: @MainActor Coordinator {
    var navigationController: UINavigationController
    var startCalled = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        startCalled = true
    }
}

/// A mock object conforming to Actionable for testing protocol parameters.
private struct MockAction: Actionable { }
