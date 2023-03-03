//
//  AppThemes.swift
//  SwiftCalculator
//
//  Created by nasrin niazi on 2023-02-11.
//

import Foundation
import UIKit
import Theme

public enum AppThemes:CaseIterable{
    case dark
    case light
    //..and so on
    
}
public extension AppThemes{
    var seletecTheme:Themeable {
        switch self{
        case .dark : return DarkTheme()
        case .light: return LightTheme()
        }
    }
}
class LightTheme: Themeable {
    
    var subViewColor: UIColor = .systemFill
    var darkButtonBGColor: UIColor = #colorLiteral(red: 1, green: 0.6001372933, blue: 0, alpha: 1)
    var darkButtonTextColor: UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    var lightButtonBGColor: UIColor = #colorLiteral(red: 0.822642982, green: 0.8276161551, blue: 0.8576098084, alpha: 1)
    var lightButtonTextColor: UIColor = #colorLiteral(red: 0.4521484375, green: 0.4521484375, blue: 0.4521484375, alpha: 1)
    var digitButtonBGColor: UIColor = #colorLiteral(red: 0.9951933026, green: 1, blue: 1, alpha: 1)
    var digitButtonTextColor: UIColor = #colorLiteral(red: 0.4521484375, green: 0.4521484375, blue: 0.4521484375, alpha: 1)
    var backgroundColor: UIColor = #colorLiteral(red: 0.9450294375, green: 0.9493623376, blue: 0.9525021911, alpha: 1)
    var labelColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var secondaryLabelColor: UIColor = #colorLiteral(red: 0.822642982, green: 0.8276161551, blue: 0.8576098084, alpha: 1)
    var switchColor: UIColor = #colorLiteral(red: 0.4521484375, green: 0.4521484375, blue: 0.4521484375, alpha: 1)
    var thumbnailImage: UIImage? = UIImage(named: "Light")
    var barStyle: UIBarStyle = .default
    var isSelected: Bool = false
}

class DarkTheme: Themeable {
    var subViewColor: UIColor = .systemFill
    var darkButtonBGColor: UIColor = #colorLiteral(red: 1, green: 0.6001372933, blue: 0, alpha: 1)
    var darkButtonTextColor: UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    var lightButtonBGColor: UIColor = #colorLiteral(red: 0.3059780598, green: 0.3137316108, blue: 0.372588098, alpha: 1)
    var lightButtonTextColor: UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    var digitButtonBGColor: UIColor = #colorLiteral(red: 0.1808412671, green: 0.1839406788, blue: 0.2197810411, alpha: 1)
    var digitButtonTextColor: UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    var backgroundColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var secondaryLabelColor: UIColor = #colorLiteral(red: 0.822642982, green: 0.8276161551, blue: 0.8576098084, alpha: 1)
    var switchColor: UIColor = #colorLiteral(red: 0.4521484375, green: 0.4521484375, blue: 0.4521484375, alpha: 1)
    var labelColor: UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    var thumbnailImage: UIImage? = UIImage(named: "Dark")!
    var isSelected: Bool = false

    var barStyle: UIBarStyle = .black
}
