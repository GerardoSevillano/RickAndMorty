//
//  RaMLocationsView.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 01/02/2023.
//

import SwiftUI

//Shows locations
struct RaMLocationsView: View {
    
    let viewModel: RaMLocationsViewViewModel
    
    // MARK: - Init
    init(viewModel: RaMLocationsViewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - SwiftUI - Body
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

struct RaMLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        RaMLocationsView(viewModel: .init())
    }
}
