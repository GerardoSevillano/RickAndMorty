//
//  RaMSearchPickerView.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 03/02/2023.
//

import Foundation
import UIKit

protocol RaMSearchPickerViewDelegate: AnyObject {
    func didDoneTapped(queryParam: URLQueryItem?)
}

//Shows pickerView with options for the filter
final class RaMSearchPickerView: UIView {
    
    weak var delegate: RaMSearchPickerViewDelegate?
    
    private var viewModel: RaMSearchPickerViewViewModel? {
        didSet {
            guard let viewModel = viewModel, !viewModel.filterOptionsValues.isEmpty else {
                return
            }
            
            createPickerView()
        }
    }
    
    // MARK: - Views
    
    @UsesAutoLayout private var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.backgroundColor = .ramBlue
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        isHidden = true
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        addSubviews(doneButton)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: RaMSearchPickerViewViewModel) {
        for view in subviews {
            if view is UIPickerView {
               view.removeFromSuperview()
           }
        }
        self.viewModel = viewModel        
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 40),
            doneButton.widthAnchor.constraint(equalToConstant: 80),
            doneButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func createPickerView() {
        
        @UsesAutoLayout var pickerView = UIPickerView()
        addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            pickerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2),
            pickerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -2),
            pickerView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: 5),
        ])
    }
    
    @objc private func didTapDoneButton() {
        guard let viewModel = self.viewModel else {
            return
        }

        delegate?.didDoneTapped(queryParam: viewModel.queryParam)
        
    }
}

// MARK: - Picker View Methods

extension RaMSearchPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel?.filterOptionsValues.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.filterOptionsValues[row] ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.setQueryParam(item: URLQueryItem(name: viewModel.filterOptionName, value: viewModel.filterOptionsValues[row]))
    }
}
