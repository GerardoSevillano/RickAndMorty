//
//  RaMCharacterDetailsViewController.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import UIKit

/// Controller to show character details
final class RaMCharacterDetailsViewController: UIViewController {
    
    private let viewModel: RaMCharacterDetailsViewViewModel
    
    @UsesAutoLayout private var characterDetailsView: RaMCharacterDetailsView
    
    // MARK: - Init
    
    init(viewModel: RaMCharacterDetailsViewViewModel) {
        self.viewModel = viewModel
        self.characterDetailsView = RaMCharacterDetailsView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("Not Supported")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(characterDetailsView)
        addConstraints()
    }
    
    // MARK: - Private

    private func addConstraints() {
        NSLayoutConstraint.activate([
            characterDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterDetailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            characterDetailsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterDetailsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
