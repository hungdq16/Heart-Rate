import Foundation
import Swinject

class TabbarAssembly: Assembly {
    func assemble(container: Container) {

        container.register(PresenterToRouterTabbarProtocol.self) { (r) in
            let router = TabbarRouter()
            return router
        }

        container.register(ViewToPresenterTabbarProtocol.self) { (r, view: TabbarVC) in
            let presenter = TabbarPresenter(view: view)
            presenter.setRouter(router: r.resolve(PresenterToRouterTabbarProtocol.self)!)
            return presenter
        }

        container.register(TabbarVC.self) { (r) in
            let vc = TabbarVC()
            vc.setPresenter(presenter: r.resolve(ViewToPresenterTabbarProtocol.self, argument: vc)!)
            return vc
        }
    }
}
