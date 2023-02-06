//
//  RaMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import UIKit

/// Controller to view and search for characters
final class RaMCharacterViewController: UIViewController {
    
    private let charactersListView = RaMCharacterListView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupView()
        addSearchButton()
        charactersListView.delegate = self
    }
    
    // MARK: - Private
    
    private func setupView() {
        view.addSubview(charactersListView)
        NSLayoutConstraint.activate([
            charactersListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            charactersListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            charactersListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            charactersListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchButton))
    }
    
    @objc private func didTapSearchButton() {
        let searchVC = RaMSearchViewController(config: .init(type: .character))
        searchVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(searchVC, animated: true)
    }
  
}

// MARK: - RaMCharacterListViewDelegate
extension RaMCharacterViewController: RaMCharacterListViewDelegate {
    func ramCharacterListView(_ characterListView: RaMCharacterListView, didSelectCharacter character: RaMCharacter) {
        let viewModel = RaMCharacterDetailsViewViewModel(character: character)
        let detailsVC = RaMCharacterDetailsViewController(viewModel: viewModel)
        detailsVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
