//
//  ProfitTests.swift
//  StockTests
//
//  Created by 조호근 on 12/11/24.
//

import Testing
import RxSwift
@testable import Domain

struct 수익계산기테스트 {
    
    let calculator = ProfitCalculatorImpl()
    let disposeBag = DisposeBag()
    
    @Test func 수익계산_양수수익_정확한값반환() {
        // Given
        let 매수단가 = 50000.0
        let 수량 = 10.0
        let 매도단가 = 55000.0
        
        let 예상총수익 = 50000.0  // (55000 - 50000) * 10
        let 예상수익률 = 10.0     // ((55000 - 50000) / 50000) * 100
        
        // When
        var 결과총수익: Double?
        var 결과수익률: Double?
        
        calculator.calculateProfit(
            averagePrice: 매수단가,
            quantity: 수량,
            salePrice: 매도단가
        )
        .subscribe(onNext: { result in
            결과총수익 = result.totalProfit
            결과수익률 = result.profitRate
        })
        .disposed(by: disposeBag)
        
        // Then
        #expect(결과총수익 == 예상총수익)
        #expect(결과수익률 == 예상수익률)
    }
    
    @Test func 수익계산_음수수익_정확한값반환() {
        // Given
        let 매수단가 = 50000.0
        let 수량 = 10.0
        let 매도단가 = 45000.0
        
        let 예상총수익 = -50000.0  // (45000 - 50000) * 10
        let 예상수익률 = -10.0     // ((45000 - 50000) / 50000) * 100
        
        // When
        var 결과총수익: Double?
        var 결과수익률: Double?
        
        calculator.calculateProfit(
            averagePrice: 매수단가,
            quantity: 수량,
            salePrice: 매도단가
        )
        .subscribe(onNext: { result in
            결과총수익 = result.totalProfit
            결과수익률 = result.profitRate
        })
        .disposed(by: disposeBag)
        
        // Then
        #expect(결과총수익 == 예상총수익)
        #expect(결과수익률 == 예상수익률)
    }
    
    @Test func 총액계산_정확한값반환() {
        // Given
        let 단가 = 50000.0
        let 수량 = 10.0
        let 예상총액 = 500000.0
        
        // When
        var 결과: Double?
        calculator.calculateTotalAmount(price: 단가, quantity: 수량)
            .subscribe(onNext: { amount in
                결과 = amount
            })
            .disposed(by: disposeBag)
        
        // Then
        #expect(결과 == 예상총액)
    }
    
}
