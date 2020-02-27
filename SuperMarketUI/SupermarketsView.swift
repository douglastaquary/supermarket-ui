//
//  SupermarketsView.swift
//  SuperMarketUI
//
//  Created by Douglas Alexandre Barros Taquary on 19/02/20.
//  Copyright © 2020 Douglas Taquary. All rights reserved.
//

import SwiftUI
import UIKit

/// A list of Supermarkets.
struct SupermarketsView : View {
    @EnvironmentObject var supermarketService: SupermarketService
    //var viewModel: SupermarketViewModel
    
    private func thumbnail(for supermarket: Supermarket) -> Image {
        if let data = supermarket.avatarJPEGData {
            return Image(uiImage: UIImage(data:data)!)
        } else {
            return Image(systemName: "cart")
        }
    }
    

    var body: some View {
        NavigationView {
            List {
                ForEach(supermarketService.supermarkets) { supermarket in
                    SupermarketCell(supermarket: supermarket)
                        .environmentObject(self.supermarketService)
                }.onDelete { indices in
                    indices.forEach {
                        self.supermarketService.deleteSupermarket(withID: self.supermarketService.supermarkets[$0].id)
                    }
                }
            }
            .navigationBarTitle(Text("Compras"))
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(
                    action: {
                        withAnimation {
                            self.supermarketService.addNewSupermarket()
                        }
                    }
                ) {
                    Image(systemName: "plus.circle.fill")
                }
            )
        }
    }
}

struct SupermarketsViewPreview : PreviewProvider {
    static var previews: some View {
        SupermarketsView()
    }
}
