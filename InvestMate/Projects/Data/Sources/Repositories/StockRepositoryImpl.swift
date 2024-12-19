//
//  StockRepositoryImpl.swift
//  Data
//
//  Created by 조호근 on 12/13/24.
//

import Foundation
import SwiftData
import Domain
import RxSwift

public final class StockRepositoryImpl: StockRepository {
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    public init() throws {
        let schema = Schema([StockModel.self])
        self.modelContainer = try ModelContainer(for: schema)
        self.modelContext = ModelContext(modelContainer)
    }
    
    public func getAllStocks() -> Observable<[Stock]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            do {
                let descriptor = FetchDescriptor<StockModel>()
                let stockModels = try self.modelContext.fetch(descriptor)
                let stocks = stockModels.map { model in
                    Stock(
                        id: model.id,
                        name: model.name,
                        averagePrice: model.averagePrice,
                        quantity: model.quantity,
                        totalPrice: model.totalPrice
                    )
                }
                observer.onNext(stocks)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    public func addStock(_ stock: Stock) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            let stockModel = StockModel(
                id: stock.id,
                name: stock.name,
                averagePrice: stock.averagePrice,
                quantity: stock.quantity,
                totalPrice: stock.totalPrice
            )
            
            self.modelContext.insert(stockModel)
            
            do {
                try self.modelContext.save()
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    public func updateStock(_ stock: Stock) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            do {
                let stockId = stock.id
                let descriptor = FetchDescriptor<StockModel>(
                    predicate: #Predicate<StockModel> { $0.id == stockId }
                )
                
                if let existingStock = try self.modelContext.fetch(descriptor).first {
                    existingStock.name = stock.name
                    existingStock.averagePrice = stock.averagePrice
                    existingStock.quantity = stock.quantity
                    existingStock.totalPrice = stock.totalPrice
                    
                    try self.modelContext.save()
                    observer.onNext(())
                    observer.onCompleted()
                }
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    public func deleteStock(_ id: UUID) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            do {
                let descriptor = FetchDescriptor<StockModel>(
                    predicate: #Predicate<StockModel> { $0.id == id }
                )
                
                if let stockToDelete = try self.modelContext.fetch(descriptor).first {
                    self.modelContext.delete(stockToDelete)
                    try self.modelContext.save()
                    observer.onNext(())
                    observer.onCompleted()
                }
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    
}
