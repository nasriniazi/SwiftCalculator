//
//  TabBarCoordinator.swift
//  SwiftCalculator
//
//  Created by nasrin niazi on 2023-02-12.
//

import Foundation
import UIKit
import Coordinator
import Calculator_UI
import FeatureToggling
import BitcoinConvertor_UI
import ConvertorCore
import Network

enum TabBarPage {
    case caculator
    case convertor
    case features
    case themes
    init?(index: Int) {
        switch index {
        case 0:
            self = .caculator
        case 1:
            self = .convertor
        case 2:
            self = .features
        case 3:
            self = .themes
        default:
            return nil
        }
    }
    func pageTitleValue() -> String {
        switch self {
        case .caculator:
            return "Calculator"
        case .convertor:
            return "Convertor"
        case .features:
            return "Features"
        case .themes:
            return "Themes"
        }
    }
    func pageOrderNumber() -> Int {
        switch self {
        case .caculator:
            return 0
        case .convertor:
            return 1
        case .features:
            return 2
        case .themes:
            return 3
        }
    }
    
}
protocol TabCoordinatorProtocol: CoordinatorProtocol {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}

class TabCoordinator: NSObject, TabCoordinatorProtocol {
    var DI: [String : Any]?
//    var repositoryDI :CoinConvertorRepositoryProtocol!

    public var featureManagerDI: FeatureToggleService!

    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController
    let jsonFeaturesUrl: URL? = Bundle.main.url(forResource: "features", withExtension: "json")

    var type: CoordinatorType { .tab }
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
        super.init()
        self.featureManagerDI = self.createFeatureManagerDI(url: self.jsonFeaturesUrl)
    }
    func createFeatureManagerDI(url:URL?)->FeatureToggleService{
        guard let url = url else{
            fatalError("\(String(describing: url)) of  json file not found")
            //TODO: handle error--log and propogate
        }
        
        let provider:FeatureToggleProvider = LocalProvider(jsonURL: url)
        return FeatureToggleService(provider: provider)
    }

    func start() {
        
        // Let's define which pages do we want to add into tab bar
        let pages:[TabBarPage] =  [.caculator,.convertor,.features,.themes].sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        
        prepareTabBarController(withTabControllers: controllers)

    }
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        /// Set delegate for UITabBarController
        tabBarController.delegate = self
        /// Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.tabBar.isTranslucent = false
        
        /// In this step, we attach tabBarController to navigation controller associated with this coordanator
        navigationController.viewControllers = [tabBarController]
    }
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(), image: UIImage(),tag: page.pageOrderNumber())
        
        switch page {
        case .caculator:
            ////            // If needed: Each tab bar flow can have it's own Coordinator.
            self.runCalculator(navController: navController)
            self.selectPage(.caculator)
        case.convertor:
            self.runConvertor(navController: navController)
            self.selectPage(.convertor)
        case .features:
            self.runFeatureToggling(navController: navController)
            self.selectPage(.features)

        case .themes:
            self.runSettingThemes(navController: navController)
            self.selectPage(.themes)

        }
        return navController
    }
    func runCalculator(navController:UINavigationController){
        let calCulatorCoordinator = CalculatorCoordinator.init(navController)
        guard let manager = self.featureManagerDI else {return}
        calCulatorCoordinator.DI = ["manager":manager]
        calCulatorCoordinator.start()
        childCoordinators.append(calCulatorCoordinator)
        
    }
    func runFeatureToggling(navController:UINavigationController){
        let featuresCoordinator = FeaturesCoordinator.init(navController)
        guard let manager = self.featureManagerDI else {return}
        featuresCoordinator.DI = ["manager":manager]
        featuresCoordinator.start()
        childCoordinators.append(featuresCoordinator)

    }

    func runConvertor(navController:UINavigationController){
        let convertorCoordinator = ConvertorCoordinator.init(navController)
        guard let manager = self.featureManagerDI else {return}
        convertorCoordinator.DI = ["manager":manager]
        convertorCoordinator.repositoryDI = createDI()
        convertorCoordinator.start()

    }
    func createDI()->CoinConvertorRepositoryProtocol{

        ///create our modules
        let network = NetworkService(config: NetworkConfig.defaultConfig)

        ///create our data manager
        let networkManager = NetworkManager(network: network)
        NetworkReachability.shared.startNetworkMonitoring()

        ///initialize repository
         return CoinConvertorRepository(networkManager: networkManager)
    }

    func runSettingThemes(navController:UINavigationController){
        let themesVC = ThemesViewController(nibName: "ThemesViewController", bundle: nil)
        navController.viewControllers = [themesVC]
        navController.popToRootViewController(animated: false)
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }

}
extension TabCoordinator : UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)
        if  let navBar = tabBarController.selectedViewController as? UINavigationController {
///remove previously added view controllers
            if navBar.viewControllers.count > 0{
                let viewControllers:[UIViewController] = navBar.viewControllers
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
            navBar.isNavigationBarHidden = true
///After that you can load selected view controller
        switch selectedIndex!{
        case 0:
            self.runCalculator(navController: navBar)
            self.selectPage(.caculator)

        case 1:
            self.runConvertor(navController: navBar)
            self.selectPage(.convertor)
            
        case 2:
            self.runFeatureToggling(navController: navBar)
            self.selectPage(.features)
        case 3:
            self.runSettingThemes(navController: navBar)
            self.selectPage(.themes)
        default:
            self.runCalculator(navController: navBar)
            self.selectPage(.caculator)

        }
    }
    }
}


