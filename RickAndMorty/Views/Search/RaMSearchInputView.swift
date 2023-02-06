//
//  RaMSearchInputView.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 02/02/2023.
//

import Foundation
import UIKit

protocol RaMSearchInputViewDelegate: AnyObject {
    func ramSearchInputView(_ inputView: RaMSearchInputView, didSelectOption option: RaMSearchInputViewViewModel.FilterOption )
    func ramSearchInputView(_ inputView: RaMSearchInputView, didEnterValueInSearchBar value: String )
    func ramSearchInputViewDidPressClear(_ inputView: RaMSearchInputView)
}

// Shows search bar and filter buttons create if neccesary
final class RaMSearchInputView: UIView {
    
    weak var delegate: RaMSearchInputViewDelegate?
    
    private var viewModel: RaMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasFilterOptions else {
                return
            }
            let filterOptions = viewModel.filterOptions
            createFilterOptionsViews(options: filterOptions)
        }
    }
    
    // MARK: - Views

    @UsesAutoLayout private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    @UsesAutoLayout private var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.backgroundColor = .ramBlue
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        clearButton.addTarget(self, action: #selector(clearSearchInput), for: .touchUpInside)
        addSubviews(searchBar, clearButton)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: RaMSearchInputViewViewModel) {
        self.viewModel = viewModel
        searchBar.placeholder = viewModel.searchPlaceHolderText
        
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            clearButton.heightAnchor.constraint(equalToConstant: 30),
            clearButton.leftAnchor.constraint(equalTo: searchBar.rightAnchor, constant: 5),
            clearButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            clearButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor)
            
        ])
    }
    
    private func createFilterOptionsViews(options: [RaMSearchInputViewViewModel.FilterOption]) {
        
        let stackView = createFilterOptionsStackView()
        options.enumerated().forEach { index, filterOption in
            let button = UIButton()
            button.setTitle(filterOption.rawValue, for: .normal)
            button.backgroundColor = .ramLightBlue
            button.setTitleColor(.label, for: .normal)
            button.layer.cornerRadius = 5
            button.tag = index
            button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func didTapFilterButton(_ sender: UIButton) {
        guard let viewModel = viewModel, viewModel.hasFilterOptions else {
            return
        }
        
        let tag = sender.tag
        let filterOption = viewModel.filterOptions[tag]
        delegate?.ramSearchInputView(self, didSelectOption: filterOption)
        
    }
    
    @objc private func clearSearchInput() {
        searchBar.text = ""
        delegate?.ramSearchInputViewDidPressClear(self)
    }
    
    
    private func createFilterOptionsStackView() -> UIStackView {
        @UsesAutoLayout var stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -2),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        return stackView
    }
}

// MARK: - UISearchBarDelegate

extension RaMSearchInputView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else {
            return
        }

        delegate?.ramSearchInputView(self, didEnterValueInSearchBar: text)
    }
}
