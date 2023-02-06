//
//  RaMCharacterEpisodesCollectionViewCellViewModel.swift.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 31/01/2023.
//

import Foundation

protocol RaMEpisodeDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class RaMCharacterEpisodesCollectionViewCellViewModel {
    
    private let apiService: APIService
    
    private let episodeURL: URL?
    
    private var isFetching = false
    
    private var dataBlock: ((RaMEpisodeDataRender) -> Void)?
    
    private var episode: RaMEpisode? {
        didSet {
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
    }
    
    // MARK: - Init

    init(episodeURL: URL?, apiService: APIService) {
        self.episodeURL = episodeURL
        self.apiService = apiService
    }
    
    // MARK: - Public

    public func registerForData(_ block: @escaping (RaMEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                self.dataBlock?(model)
            }
            return
        }
        guard let url = episodeURL, let ramRequest = RaMRequest(url: url) else {
            return
        }
        
        isFetching = true
        
        apiService.executeRequest(ramRequest, expecting: RaMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
