//
//  AppCoordinator.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 24/03/24.
//

import Foundation
import UIKit

protocol AppCoordinatorProtocol: CoordinatorProtocol {
    func goToDetail(person: PersonModel, from vc: UIViewController)
}

final class AppCoordinator: AppCoordinatorProtocol {
    // MARK: - Properties
    private let navController: UINavigationController
    private let window: UIWindow

    // MARK: - Initializer
    init(navController: UINavigationController, window: UIWindow) {
        self.navController = navController
        navController.navigationBar.isHidden = true
        self.window = window
    }

    func start() {
        window.rootViewController = navController
        window.makeKeyAndVisible()
        showMainStoryboard()
    }

    // MARK: - Navigation
    private func showMainStoryboard() {
        let masterVC = MasterViewController.instantiate()
        
        let viewModel = MasterViewModel()
        viewModel.coordinator = self
        viewModel.vc = masterVC
        
        masterVC.viewModel = viewModel
      
        navController.setViewControllers([masterVC], animated: true)
    }
    
    func goToDetail(person: PersonModel, from vc: UIViewController) {
        let viewModel = DetailViewModel()
        viewModel.person = person
        viewModel.coordinator = self
        
        let detailVC = DetailViewController.instantiate()
        detailVC.modalPresentationStyle = .pageSheet
        detailVC.viewModel = viewModel
        
        vc.present(detailVC, animated: true)
    }
}
