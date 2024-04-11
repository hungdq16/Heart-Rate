//
//  SplashVC.swift
//  InPulseDemo
//
//  Created by Hùng Đặng on 10/04/2024.
//

import UIKit
import AdsModule
import Analytics
import AppTrackingTransparency

class SplashVC: UIViewController, PresenterToViewSplashProtocol {
    // MARK: - Properties
    private var presenter: ViewToPresenterSplashProtocol?
    private let consentManagement = BralyConsentFormManagement()
    func setPresenter(presenter: ViewToPresenterSplashProtocol) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter?.checkFTU()
        presenter?.checkPremium()
        BralyTracking.shared.logEvent(eventName: "splash_show", params: nil)
    }

    private func setupViews() {
        
    }
    
    func needToShowRequestAttModal() -> Bool {
        guard #available(iOS 14, *) else { return false }
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .notDetermined:
            return true
        default:
            return false
        }
    }
}

extension SplashVC {
    func requestATT() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if self.needToShowRequestAttModal() {
                ATTrackingManager.requestTrackingAuthorization { status in
                    if status == .authorized {
                        BralyTracking.shared.logEvent(eventName: "ftu_splash_allow_tracking", params: nil)
                    }
                    self.checkConsent()
                }
            } else {
                self.checkConsent()
            }
        })
    }
    
    func checkConsent() {
        consentManagement.delegate = self
        DispatchQueue.main.async {
            self.consentManagement.showConsentForm(from: self, isForceShowConsentWhenRejectBefore: false)
        }
    }
    
    func showAdsOpen() {
        BralyAdvertisement.shared.showOpenAd(from: self) {
            self.presenter?.openNextScreen()
        }
    }
}

extension SplashVC: BralyResultConsentFormDelegate {
    func onShowConsentForm() {
        print("[LOG][ADS][Consent][✅] onShowConsentForm")
    }
    
    func onConsentFull(isConsentFullBefore: Bool) {
        print("[LOG][ADS][Consent][✅] onConsentFull")
        presenter?.initMobileAdsSDK()
        BralyTracking.shared.logEvent(eventName: "ftu_splash_allow_cmp", params: nil)
    }
    
    func onConsentReject() {
        print("[LOG][ADS][Consent][❌] onConsentReject")
        presenter?.initMobileAdsSDK()
    }
    
    func onConsentCustom(consentPurpose: Int, consentVendor: Int) {
        print("[LOG][ADS][Consent][✅] onConsentCustom")
        presenter?.initMobileAdsSDK()
        BralyTracking.shared.logEvent(eventName: "ftu_splash_click_manage_permission", params: nil)
    }
    
    func onConsentSkip() {
        print("[LOG][ADS][Consent][✅] onConsentSkip")
        presenter?.initMobileAdsSDK()
    }
    
    func onError(error: Error) {
        print("[LOG][ADS][Consent][❌] on error \(error.localizedDescription)")
        presenter?.initMobileAdsSDK()
    }
}

