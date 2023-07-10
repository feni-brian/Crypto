//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by Feni Brian on 06/06/2022.
//

import CoreData
import SwiftUI

class PortfolioDataService {
//    static let shared = PersistenceController()
    let container: NSPersistentContainer
    @Published var savedEntities: [PortfolioEntity] = []

//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//        for _ in 0..<5 {
//            let newItem = PortfolioEntity(context: viewContext)
//            newItem.coinID = "ethereum"
//            newItem.amount = 1.5
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Crypto")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
//        container.viewContext.automaticallyMergesChangesFromParent = true
        self.getPortfolio()
    }
    
    //MARK: - PUBLIC
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // Check if the coin already exists in our portfolio
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                updateItem(entity: entity, amount: amount)
            } else {
                deleteItem(entity: entity)
            }
        } else {
            addItem(coin: coin, amount: amount)
        }
    }
    
    // MARK: - PRIVATE
    
    private func getPortfolio() {
        do {
            savedEntities = try container.viewContext.fetch(NSFetchRequest<PortfolioEntity>(entityName: "PortfolioEntity"))
        } catch let error {
            print("Error getting portfolio: \(error)")
        }
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func updateItem(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        save()
        getPortfolio()
    }
    
    private func addItem(coin: CoinModel, amount: Double) {
        withAnimation {
            let newItem = PortfolioEntity(context: container.viewContext)
            newItem.coinID = coin.id
            newItem.amount = amount
            
            save()
            getPortfolio()
        }
    }

    private func deleteItem(entity: PortfolioEntity) {
        withAnimation {
            container.viewContext.delete(entity)
            save()
            getPortfolio()
        }
    }
}
