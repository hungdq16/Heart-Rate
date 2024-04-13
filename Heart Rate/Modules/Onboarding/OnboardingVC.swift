//
//  OnboardingVC.swift
//  InPulseDemo
//
//  Created by Hùng Đặng on 10/04/2024.
//

import UIKit
import Analytics

class OnboardingVC: UIViewController, PresenterToViewOnboardingProtocol {
    // MARK: - Properties
    private var presenter: ViewToPresenterOnboardingProtocol?
    
    func setPresenter(presenter: ViewToPresenterOnboardingProtocol) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        BralyTracking.shared.logScreenView(screenName: "ftu_ob1_show")
    }
    @IBAction func onClickedGoBtn(_ sender: Any) {
        let tabbarNavi = TabbarRouter.createModule(isFromOnboarding: true)
        UIApplication.shared.windows.first?.rootViewController = tabbarNavi
    }
}

extension OnboardingVC {
    private func setupView() {
        
    }
    
}
