//
//  RaMLocationViewController.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import UIKit
import SwiftUI

/// Controller to view episodes
final class RaMLocationViewController: UIViewController {
    
    private let locationsSwiftUIController = UIHostingController(rootView: RaMLocationsView(viewModel: .init()))

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Locations"
        view.backgroundColor = .systemBackground
        addSwiftUIController()
    }
    
    // MARK: - Private
    
    private func addSwiftUIController() {
        addChild(locationsSwiftUIController)
        locationsSwiftUIController.didMove(toParent: self)
        
        view.addSubview(locationsSwiftUIController.view)
        locationsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        locationsSwiftUIController.view.backgroundColor = .ramLightBlue
        
        NSLayoutConstraint.activate([
            locationsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            locationsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            locationsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
