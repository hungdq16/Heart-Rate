import Foundation
import Swinject

final class SplashRouter: PresenterToRouterSplashProtocol {
    
    // MARK: - Static methods
    static func createModule() -> UIViewController {
        let viewController = Container.shared.resolve(SplashVC.self)!
        return viewController
    }
    
    func openOnboarding() {
        let onboardingNavi = OnboardingRouter.createModule()
        UIApplication.shared.windows.first?.rootViewController = onboardingNavi
    }
    
    func openMainTab() {
        let tabbarNavi = TabbarRouter.createModule(isFromOnboarding: false)
        UIApplication.shared.windows.first?.rootViewController = tabbarNavi
    }
}
