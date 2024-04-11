import Foundation
import Common

class TabbarPresenter: ViewToPresenterTabbarProtocol {
    
    // MARK: - Properties
    private weak var view: PresenterToViewTabbarProtocol?
    private var router: PresenterToRouterTabbarProtocol?

    init(view: PresenterToViewTabbarProtocol) {
        self.view = view
    }
    
    // MARK: - Init
    func setRouter(router: PresenterToRouterTabbarProtocol) {
        self.router = router
    }
}
