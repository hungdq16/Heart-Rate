import Foundation
import Swinject

final class TabbarRouter: PresenterToRouterTabbarProtocol {
    
    // MARK: - Static methods
    static func createModule(isFromOnboarding: Bool) -> UIViewController {
        let viewController = Container.shared.resolve(TabbarVC.self, argument: isFromOnboarding)!
        return viewController
    }
}
