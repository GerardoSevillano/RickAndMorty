//
//  RaMSearchViewController.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 01/02/2023.
//

import UIKit

/// Controller to search that adapts to a configuration
final class RaMSearchViewController: UIViewController {

    struct Config {
        enum `Type` {
            case character
            case episode
            case location
        }
        
        var title: String {
            switch type {
            case .character:
                return "Search Characters"
            case .location:
                return "Search Locations"
            case .episode:
                return "Search Episodes"
            }
        }
        
        var endpointValue: String {
            switch type {
            case .character:
                return "character"
            case .location:
                return "location"
            case .episode:
                return "episode"
            }
        }
        
        var filterEndpoint: RaMEndpoint {
            return RaMEndpoint(rawValue: endpointValue)!
        }
        
        let type: `Type`
    }
    
    private let viewModel: RaMSearchViewViewModel
    
    // MARK: - Views
    
    @UsesAutoLayout private var searchView: RaMSearchView
    @UsesAutoLayout private var filterView: RaMSearchPickerView
    
    // MARK: - Init
    
    init(config: Config) {
        let viewModel = RaMSearchViewViewModel(config: config, apiService: RaMService(cacheManager: RaMAPICacheManager()))
        self.viewModel = viewModel
        self.searchView = RaMSearchView(frame: .zero, viewModel: viewModel)
        self.filterView = RaMSearchPickerView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(searchCharacters))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.title
        view.addSubviews(searchView, filterView)
        searchView.delegate = self
        filterView.delegate = self
        addConstraints()
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            filterView.heightAnchor.constraint(equalToConstant: 300),
            filterView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            filterView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            filterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func searchCharacters() {
        viewModel.executeSearch()
    }
}

// MARK: - RaMSearchViewDelegate

extension RaMSearchViewController: RaMSearchViewDelegate {
    
    func ramSearchView(_ searchView: RaMSearchView, didSelectCharacter character: RaMCharacter) {
        let viewModel = RaMCharacterDetailsViewViewModel(character: character)
        let detailsVC = RaMCharacterDetailsViewController(viewModel: viewModel)
        detailsVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func ramSearchViewDidPressClear(_ inputView: RaMSearchView) {
        viewModel.clearQueryParams()
    }
    
    func ramSearchView(_ searchView: RaMSearchView, didEnterValueInSearchBar value: String) {
        viewModel.addQueryParam(param: URLQueryItem(name: "name", value: value))
    }
    
    func ramSearchView(_ searchView: RaMSearchView, didSelectFilterOption option: RaMSearchInputViewViewModel.FilterOption) {
        
        filterView.configure(with: RaMSearchPickerViewViewModel(type: option))
        filterView.isHidden = false
    }
}

// MARK: - RaMSearchPickerViewDelegate

extension RaMSearchViewController: RaMSearchPickerViewDelegate {
    func didDoneTapped(queryParam: URLQueryItem?) {
        guard let queryParam = queryParam else {
            return
        }
        viewModel.addQueryParam(param: queryParam)
        filterView.isHidden = true
    }
}





