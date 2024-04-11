import Foundation

// MARK: - View Output (Presenter -> View)

protocol PresenterToViewTabbarProtocol: AnyObject {
    func setPresenter(presenter: ViewToPresenterTabbarProtocol)
}

// MARK: - View Input (View -> Presenter)
protocol ViewToPresenterTabbarProtocol: AnyObject {
    func setRouter(router: PresenterToRouterTabbarProtocol)
}

// MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterTabbarProtocol: AnyObject {

}
