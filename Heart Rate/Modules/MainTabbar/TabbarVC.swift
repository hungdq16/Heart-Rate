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
import Foundation

class TabbarVC: UIViewController, PresenterToViewTabbarProtocol {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var tabbarContainer: UIView!
    @IBOutlet weak var tabbar: UITabBar!
    
    let btnMiddle : UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        btn.setTitle("", for: .normal)
        btn.backgroundColor = R.color.white()
        btn.layer.cornerRadius = 30
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.setBackgroundImage(R.image.ic_measure_btn(), for: .normal)
        return btn
    }()
    
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
        self.tabbar.addSubview(btnMiddle)
        setupCustomTabBar()
        btnMiddle.frame = CGRect(x: Int(self.tabbar.bounds.width)/2 - 30, y: -25, width: 60, height: 60)
        if isFromOnboarding {
            BralyTracking.shared.logScreenView(screenName: "ftu_home_show")
        }
    }
    
    func setupCustomTabBar() {
        let path : UIBezierPath = getPathForTabBar()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.white.cgColor
        self.tabbar.layer.insertSublayer(shape, at: 0)
        self.tabbar.itemWidth = 40
        self.tabbar.itemPositioning = .centered
        self.tabbar.itemSpacing = 180
        self.tabbar.tintColor = R.color.white()
    }
    
    func getPathForTabBar() -> UIBezierPath {
        let frameWidth = self.tabbar.bounds.width
        let frameHeight = self.tabbar.bounds.height + 50// Khoảng cách từ button đến cạnh dưới
        let path: UIBezierPath = UIBezierPath()
        
        let height: CGFloat = 45
        let centerWidth = frameWidth / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height * 2 + 20), y: 0)) // the beginning of the trough
        
        // first curve down
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 35), y: 0),
                      controlPoint2: CGPoint(x: centerWidth - 40, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2 - 20), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 40, y: height),
                      controlPoint2: CGPoint(x: (centerWidth + 35), y: 0))
        
        // complete the rect
        path.addLine(to: CGPoint(x: frameWidth, y: 0))
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight))
        path.addLine(to: CGPoint(x: 0, y: frameHeight))
        path.close()
        
        return path
    }
}
