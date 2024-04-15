import Foundation
import Swinject

class SplashAssembly: Assembly {
    func assemble(container: Container) {

        container.register(PresenterToRouterSplashProtocol.self) { (r) in
            let router = SplashRouter()
            return router
        }

        container.register(ViewToPresenterSplashProtocol.self) { (r, view: SplashVC) in
            let purchaseService = Container.shared.resolve(PurchaseService.self)!
            let presenter = SplashPresenter(view: view, purchaseService: purchaseService)
            
            if let router = r.resolve(PresenterToRouterSplashProtocol.self) {
                presenter.setRouter(router: router)
            } else {
                print("check>>>")
            }
            return presenter
        }

        container.register(SplashVC.self) { (r) in
            let vc = SplashVC()
            vc.setPresenter(presenter: r.resolve(ViewToPresenterSplashProtocol.self, argument: vc)!)
            return vc
        }
    }
}
