//
//  SupermarkView.swift
//  SuperMarketUI
//
//  Created by Douglas Alexandre Barros Taquary on 19/02/20.
//  Copyright © 2020 Douglas Taquary. All rights reserved.
//

import SwiftUI

/// Detail view for a Contact
struct SupermarketView: View {
    @EnvironmentObject var viewModel: SupermarketViewModel
    var supermarketID: Supermarket.ID
    
    /// Binding used to track edits. When a field is edited, it triggers an update
    /// to this binding, which passes the change directly to the viewModel, and thus
    /// the store
    private var supermarket: Binding<Supermarket> {
        Binding<Supermarket>(
            get: { () -> Supermarket in
                self.viewModel.supermarket(withID: self.supermarketID)
            },
            set: { newSupermarket in
                self.viewModel.update(newSupermarket)
            }
        )
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Nome", text: supermarket.name)
                    TextField("Endereço", text: supermarket.address.streetAddress)
                }
                Section(header: Text("Address")) {
                    TextField("Street Address", text: supermarket.address.streetAddress)
                    TextField("City", text: supermarket.address.city)
                    TextField("Country", text: supermarket.address.country)
                }
            }
            .navigationBarTitle(Text("Supermarket"))
        }
    }
}

