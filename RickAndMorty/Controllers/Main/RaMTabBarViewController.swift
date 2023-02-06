//
//  RaMTabBarViewController.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import UIKit

/// Contains tabs and root tab controllers
final class RaMTabBarViewController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTabs()
        configureTabBar()
    }
    
    // MARK: - Private
    
    private func prepareTabs() {
        let charactersVC = RaMCharacterViewController()
        let episodesVC = RaMEpisodeViewController()
        let locationsVC = RaMLocationViewController()
        
        let viewControllers = [charactersVC, episodesVC, locationsVC]
        viewControllers.forEach { vc in
            vc.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        let charactersNavController = UINavigationController(rootViewController: charactersVC)
        let episodesNavController = UINavigationController(rootViewController: episodesVC)
        let locationsNavController = UINavigationController(rootViewController: locationsVC)
        
        charactersNavController.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(systemName: "person"),
            tag: 1
        )
        episodesNavController.tabBarItem = UITabBarItem(
            title: "Episodes",
            image: UIImage(systemName: "tv"),
            tag: 2
        )
        locationsNavController.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(systemName: "globe"),
            tag: 3
        )
        
        let navigationControllers = [charactersNavController, episodesNavController, locationsNavController]
        navigationControllers.forEach { nav in
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([charactersNavController, episodesNavController, locationsNavController], animated: true
        )
    }
    
    private func configureTabBar(){
        tabBar.tintColor = .ramBlue
    }

}

