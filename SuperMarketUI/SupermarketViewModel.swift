//
//  SupermarketViewModel.swift
//  SuperMarketUI
//
//  Created by Douglas Alexandre Barros Taquary on 25/02/20.
//  Copyright © 2020 Douglas Taquary. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import LLVS
import LLVSCloudKit
import CloudKit

final class SupermarketViewModel: ObservableObject {
    
    let storeCoordinator: StoreCoordinator
    
    private var supermarketSubscriber: AnyCancellable?
    
    init(storeCoordinator: StoreCoordinator) {
        self.storeCoordinator = storeCoordinator
        supermarketSubscriber = storeCoordinator.currentVersionSubject
            .receive(on: DispatchQueue.main)
            .map( { self.fetchedSupermarkets(at: $0) })
            .assign(to: \.items, on: self)
    }
    
    
    @Published var items: [Supermarket] = []

    private func fetchedSupermarkets(at version: Version.Identifier) -> [Supermarket] {
        return try! Supermarket.all(in: storeCoordinator, at: version).sorted(by: {
            (($0.name, $0.id.uuidString) < ($1.name, $1.id.uuidString))
        })
    }
    
    func addNewSupermarket() {
        let newSupermarket = Supermarket()
        let change: Value.Change = .insert(try! newSupermarket.encodeValue())
        try! storeCoordinator.save([change])
        sync()
    }
    
    func update(_ supermarket: Supermarket) {
        let change: Value.Change = .update(try! supermarket.encodeValue())
        try! storeCoordinator.save([change])
        sync()
    }
    
    func deleteSupermarket(withID id: Supermarket.ID) {
        let change: Value.Change = .remove(Supermarket.storeValueId(for: id))
        try! storeCoordinator.save([change])
        sync()

    }
    
    func supermarket(withID id: Supermarket.ID) -> Supermarket {
        return items.first(where: { $0.id == id }) ?? Supermarket()
    }
    
    // MARK: Syncing
    
    func sync(executingUponCompletion completionHandler: ((Swift.Error?) -> Void)? = nil) {
        storeCoordinator.exchange { _ in
            self.storeCoordinator.merge()
        }
    }
}
