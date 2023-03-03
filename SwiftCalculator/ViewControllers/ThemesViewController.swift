//
//  SettingViewController.swift
//  
//
//  Created by nasrin niazi on 2023-02-08.
//

import UIKit

class ThemesViewController: UIViewController {
    
    @IBOutlet weak var themeView: ThemesView!
    override func viewDidLoad() {
        super.viewDidLoad()
        themeView.frame = CGRect(x: themeView.frame.origin.x, y: themeView.frame.origin.y, width: themeView.frame.size.width, height: themeView.intrinsicContentSize.height)
        
    }
}
