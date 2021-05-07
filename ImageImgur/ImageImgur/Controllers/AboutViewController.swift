//
//  AboutViewController.swift
//  ImageImgur
//
//  Created by Mohammed Ramshad K on 08/05/21.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var buildNumber: UILabel!
    @IBOutlet weak var buildTime: UILabel!
    @IBOutlet weak var auther: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgView.layer.cornerRadius = 20
        self.bgView.layer.masksToBounds = true
        buildNumber.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
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
