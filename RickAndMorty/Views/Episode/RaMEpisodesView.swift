//
//  RaMEpisodesView.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 01/02/2023.
//

import SwiftUI

//Shows episodes
struct RaMEpisodesView: View {
    
    let viewModel: RaMEpisodesViewViewModel
    
    // MARK: - Init
    init(viewModel: RaMEpisodesViewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - UI
    var body: some View {
        
        VStack {
            Image(uiImage: viewModel.image!).renderingMode(.template).resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)).aspectRatio(contentMode: .fit).foregroundColor(Color("RaMBlue"))
            Text(viewModel.title)
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(Color("RaMBlue"))
                .multilineTextAlignment(.center)
        }
    }
}

struct RaMEpisodesView_Previews: PreviewProvider {
    static var previews: some View {
        RaMEpisodesView(viewModel: .init())
    }
}
