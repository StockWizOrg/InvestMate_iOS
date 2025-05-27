//
//  StockListReactor.swift
//  Presentation
//
//  Created by 조호근 on 12/24/24.
//

import Foundation
import Domain

import ReactorKit
import RxSwift

public final class StockListReactor: Reactor {
    
    public enum Action {
        case refresh
        case deleteStock(UUID)
    }
    
    public enum Mutation {
        case setStocks([Stock])
        case setLoading(Bool)
    }
    
    public struct State {
        var stocks: [Stock] = []
        var isLoading: Bool = false
    }
    
    public let initialState: State
    private let stockManager: StockManagementUseCase
    
    init(stockManager: StockManagementUseCase) {
        self.initialState = State()
        self.stockManager = stockManager
        
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        print("Mutating with action:", action)
        switch action {
        case .refresh:
            return .concat([
                .just(.setLoading(true)),
                stockManager.getAllStocks()
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                    .observe(on: MainScheduler.instance)
                    .do(onNext: { stocks in stocks.debugLog(label: "1️⃣1️⃣Fetched stocks") })
                    .map { .setStocks($0) },
                .just(.setLoading(false))
            ])
            
        case let .deleteStock(id):
            return .concat([
                .just(.setLoading(true)),
                stockManager.deleteStock(id: id)
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                    .observe(on: MainScheduler.instance)
                    .flatMap { [weak self] _ -> Observable<Mutation> in
                        guard let self = self else { return .empty() }
                        return self.stockManager.getAllStocks()
                            .map { .setStocks($0) }
                    },
                .just(.setLoading(false))
            ])
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setStocks(stocks):
            stocks.debugLog(label: "2️⃣2️⃣Reducing with stocks")
            newState.stocks = stocks
            
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        
        return newState
    }
    
}

extension StockListReactor {
    
    func getStockManager() -> StockManagementUseCase {
        return stockManager
    }
    
}
