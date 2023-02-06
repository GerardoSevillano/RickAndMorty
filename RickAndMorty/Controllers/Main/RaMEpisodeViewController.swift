//
//  RaMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import UIKit
import SwiftUI

/// Controller to view episodes
final class RaMEpisodeViewController: UIViewController {
    
    private let episodesSwiftUIController = UIHostingController(rootView: RaMEpisodesView(viewModel: .init()))

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episodes"
        view.backgroundColor = .systemBackground
        addSwiftUIController()
    }
    
    // MARK: - Private
    
    private func addSwiftUIController() {
        addChild(episodesSwiftUIController)
        episodesSwiftUIController.didMove(toParent: self)
        
        view.addSubview(episodesSwiftUIController.view)
        episodesSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        episodesSwiftUIController.view.backgroundColor = .ramLightBlue
        NSLayoutConstraint.activate([
            episodesSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodesSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            episodesSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodesSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
