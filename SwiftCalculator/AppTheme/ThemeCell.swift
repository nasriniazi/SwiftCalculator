//
//  ThemeCell.swift
//  SwiftCalculator
//
//  Created by nasrin niazi on 2023-02-12.
//

import UIKit
import Theme

protocol ThemeSelectionDelegate:AnyObject {
    //always triggers when the OTP field is valid
    func didChangeTheme(_ toTheme:Themeable )
}

class ThemeCell: UICollectionViewCell {
    @IBOutlet weak var themeSelectionButton: UIButton!
    var cellTheme:Themeable!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    var delegate:ThemeSelectionDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.themeSelectionButton.setImage(UIImage(systemName: "app"), for: .normal)
        self.themeSelectionButton.setImage(UIImage(systemName: "app.fill"), for: .selected)
        self.thumbnailImageView.layer.masksToBounds = true
        self.thumbnailImageView.layer.cornerRadius = 25
        
    }
    func configureCell(_ theme:Themeable){
        self.cellTheme = theme
        self.thumbnailImageView.image = theme.thumbnailImage
        self.themeSelectionButton.tintColor = theme.digitButtonBGColor
        if theme.isSelected {
            self.isSelected = true
            self.toggleSelected()
        }
    }
    func toggleSelected(){
        if isSelected {
            self.cellTheme.isSelected = true
            self.themeSelectionButton.isSelected = true
            delegate.didChangeTheme(cellTheme)
        }
        else{
            self.cellTheme.isSelected = false
            self.themeSelectionButton.isSelected = false
            
        }
        
    }
}
