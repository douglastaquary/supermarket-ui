//
//  SupermarketCell.swift
//  SuperMarketUI
//
//  Created by Douglas Alexandre Barros Taquary on 19/02/20.
//  Copyright © 2020 Douglas Taquary. All rights reserved.
//

import SwiftUI

/// Cell used in the main contacts list. When tapped, it pushes
/// the ContactView to edit the Contact
struct SupermarketCell: View {
    @EnvironmentObject var viewModel: SupermarketViewModel
    var supermarketID: Supermarket.ID
    var supermarket: Supermarket { viewModel.supermarket(withID: supermarketID) }

    var body: some View {
        NavigationLink(
            destination:
                SupermarketView(supermarketID: supermarketID)
                    .environmentObject(viewModel)
        ) {
            HStack {
                SupermarketThumbnail(supermarket: supermarket)
                VStack(alignment: .leading) {
                    Text(supermarket.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct SupermarketThumbnail: View {
    var supermarket: Supermarket
    var body: some View {
        var image: Image
        if let data = supermarket.avatarJPEGData {
            image = Image(uiImage: UIImage(data:data)!)
        } else {
            image = Image(systemName: "cart")
        }
        return image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(4.0)
            .frame(width: 40, height: 40, alignment: .center)
            .foregroundColor(.green)
    }
}
