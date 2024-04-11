//
//  TabbarVC.swift
//  Heart Rate
//
//  Created by Hùng Đặng on 11/04/2024.
//

import UIKit

class TabbarVC: UIViewController, PresenterToViewTabbarProtocol {
    // MARK: - Properties
    private var presenter: ViewToPresenterTabbarProtocol?
    
    func setPresenter(presenter: ViewToPresenterTabbarProtocol) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
