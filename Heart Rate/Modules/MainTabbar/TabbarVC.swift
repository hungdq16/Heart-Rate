//
//  TabbarVC.swift
//  Heart Rate
//
//  Created by Hùng Đặng on 11/04/2024.
//

import UIKit
import Swinject
import Combine
import AdsModule
import Analytics

class TabbarVC: UIViewController, PresenterToViewTabbarProtocol {
    // MARK: - Properties
    private var presenter: ViewToPresenterTabbarProtocol?
    
    private var viewControllers = [UIViewController]()
    var shouldHideStatusBar: Bool = false
    private var isFromBackground = false
    private var isFirstTime: Bool = true
    private let isFromOnboarding: Bool
    
    init(isFromOnboarding: Bool) {
        self.isFromOnboarding = isFromOnboarding
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

//    private var additionalBottomInset: CGFloat {
//        get {
//            return tabBar.bounds.height
//        }
//    }
    
//    private var bannerOffset: Double {
//        get {
//            return isMiniPlayerShowing ? 60 : 0
//        }
//    }
    
    func setPresenter(presenter: ViewToPresenterTabbarProtocol) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromOnboarding {
            BralyTracking.shared.logScreenView(screenName: "ftu_home_show")
        }
    }
}
