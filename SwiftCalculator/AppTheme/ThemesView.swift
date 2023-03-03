//
//  ThemesView.swift
//  SwiftCalculator
//
//  Created by nasrin niazi on 2023-02-12.
//

import UIKit
import Theme

class ThemesView: UIView {
    
    @IBOutlet weak var collectionViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var view: SecondView!
    var themes:[Themeable?] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        csutomInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        csutomInit()
    }
    func csutomInit(){
        let view = Bundle.main.loadNibNamed("ThemesView", owner: self, options: nil)?.first as? UIView
        view?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view?.frame = self.bounds
        addSubview(view!)
        self.themes = AppThemes.allCases.map{$0.seletecTheme}
        initCollectionView()
    }
    
    private func initCollectionView() {
        let nib = UINib(nibName: "ThemeCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ThemeCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: MyThemeConstant.Sizes.themeCollectionViewCellWidth, height: MyThemeConstant.Sizes.themeCollectionViewCellHeight)
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.minimumInteritemSpacing = 5.0
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.allowsMultipleSelection = false
        
        
    }
    func viewDidLayoutSubviews() {
        let width = collectionView.collectionViewLayout.collectionViewContentSize.width
        collectionViewWidthConstraint.constant = width
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.frame.size.width = width + 60
        
        self.view.layoutIfNeeded()
    }
    
}
extension ThemesView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.themes.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell:ThemeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCell", for: indexPath) as? ThemeCell else {
            fatalError("can't dequeue CustomCell")
        }
        cell.delegate = self
        if let currentTheme = themes[indexPath.row] {
            
            cell.configureCell(currentTheme)
        }
        return cell
    }
}
extension ThemesView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCell:ThemeCell = collectionView.cellForItem(at: indexPath) as? ThemeCell{
            selectedCell.toggleSelected()
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedCell:ThemeCell = collectionView.cellForItem(at: indexPath) as? ThemeCell{
            selectedCell.toggleSelected()
        }
        
    }
}
extension ThemesView:ThemeSelectionDelegate{
    func didChangeTheme(_ toTheme: Themeable) {
        toTheme.apply(for: UIApplication.shared)
    }
    
}

