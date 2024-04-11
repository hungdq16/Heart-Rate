import Foundation
import AdsModule
import BralyLogger
import Analytics

class SplashPresenter: ViewToPresenterSplashProtocol {
    
    // MARK: - Properties
    private weak var view: PresenterToViewSplashProtocol?
    private var router: PresenterToRouterSplashProtocol?
    private var purchaseService: PurchaseService
    
    init(view: PresenterToViewSplashProtocol, purchaseService: PurchaseService) {
        self.view = view
        self.purchaseService = purchaseService
    }
    
    // MARK: - Init
    func setRouter(router: PresenterToRouterSplashProtocol) {
        self.router = router
    }
    
    func checkFTU() {
        if AppService.shared.isFirstTimeUsing() {
            return
        }
        BralyTracking.shared.logScreenView(screenName: "ftu_splash_show")
    }
    
    @MainActor
    func checkPremium() {
        Task {
//            let isPremium = await purchaseService.isPremium()
//            if isPremium {
//                AppService.shared.isPremiumSubscription = true
                router?.openMainTab()
//            } else {
//                view?.requestATT()
//            }
        }
    }
    
    @MainActor
    func initMobileAdsSDK() {
        let config = Configuration(isDebug: false, defaultAds: "ads_config_v1")
        BralyMobileAds.shared.initializeAds(configuration: config)
        Task {
            await fetchAdsConfig()
            getIAPScenario()
        }
    }
    
    func openMainTab() {
        router?.openMainTab()
    }
    
    func openNextScreen() {
        let isFirstTime = AppService.shared.isFirstTimeUsing()
        if isFirstTime {
            router?.openMainTab()
        } else {
            router?.openOnboarding()
        }
    }
    
    @MainActor
    private func fetchAdsConfig() async {
        do {
            try await FirebaseRemoteConfigService.shared.initialize()
            let response: AdManagement? = FirebaseRemoteConfigService.shared.getJson(config: ConfigConstants.keyAdsConfig)
            BralyAdvertisement.shared.setAdConfig(adManagement: response)
            loadAds()
        } catch {
            Logger.e(messages: "Fetch remote config failed with error: \(error)")
            if let path = Bundle.main.url(forResource: "ads_config", withExtension: "json") {
                do {
                    let jsonData = try Data(contentsOf: path)
                    let adsConfig = try JSONDecoder().decode(AdManagement.self, from: jsonData)
                    BralyAdvertisement.shared.setAdConfig(adManagement: adsConfig)
                    Logger.d(messages: "Fetching local ads config success")
                    loadAds()
                } catch {
                    Logger.e(messages: "Error fetching local ads config: \(error.localizedDescription)")
                    loadAds()
                }
            } else {
                Logger.e(messages: "Error fetching local ads config file")
                loadAds()
            }
        }
    }
    
    private func loadAds() {
//        BralyAdvertisement.shared.loadInterstitial(configKey: AdsKey.fullChangeTab.rawValue) {
//            Logger.d(messages: "load ad interstitial done")
//        }
//        
//        BralyAdvertisement.shared.loadInterstitial(configKey: AdsKey.fullPlayer.rawValue) {
//            Logger.d(messages: "load ad interstitial done")
//        }
        
        BralyAdvertisement.shared.fetchOpenAds(adConfigKey: AdsKey.openAds.rawValue) { [weak self] success, error in
            if let error = error {
                Logger.e(messages: "load open app ad failed with error: \(error)")
                self?.openNextScreen()
                return
            }
            Logger.d(messages: "load open app ad \(success)")
            self?.view?.showAdsOpen()
        }
    }
    
    private func getIAPScenario() {
        let response: IAPScenarioModel? = FirebaseRemoteConfigService.shared.getJson(config: ConfigConstants.keyIAPScenario)
        Logger.d(messages: "Fetching iap scenario config completed \(String(describing: response))")
        AppService.shared.iapScenario = response?.iapPosition
    }
}
