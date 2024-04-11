import Foundation

// MARK: - View Output (Presenter -> View)
protocol PresenterToViewSplashProtocol: AnyObject {
    func setPresenter(presenter: ViewToPresenterSplashProtocol)
    func showAdsOpen()
    func requestATT()
}

// MARK: - View Input (View -> Presenter)
protocol ViewToPresenterSplashProtocol: AnyObject {
    func setRouter(router: PresenterToRouterSplashProtocol)
    func initMobileAdsSDK()
    func openNextScreen()
    func checkPremium()
    func checkFTU()
}

// MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterSplashProtocol: AnyObject {
    func openOnboarding()
    func openMainTab()
}
