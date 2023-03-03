//
//  AppCoordinator.swift
//  SwiftCalculator
//
//  Created by nasrin niazi on 2023-02-11.
//

import Foundation
import UIKit
import Coordinator

protocol AppCoordinatorProtocol: CoordinatorProtocol {
    func runMainFlow()
}
class AppCoordinator: AppCoordinatorProtocol {
    
    var DI: [String : Any]?
    
    func start() {
        runMainFlow()
    }
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    var navigationController: UINavigationController
    var childCoordinators = [CoordinatorProtocol]()
    var type: CoordinatorType { .app }
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func runMainFlow() {
        let tabCoordinator = TabCoordinator.init(self.navigationController)
        tabCoordinator.start()
        self.childCoordinators.append(tabCoordinator)
    }
}
