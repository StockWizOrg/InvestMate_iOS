import Testing
import RxSwift
@testable import Domain

struct 추가매수계산테스트 {

    let calculator = StockCalculatorImpl()
    let disposeBag = DisposeBag()
    
    @Test func 총액계산_계산한값반환() {
        
        // Given
        let 평균단가 = 50000.0
        let 수량 = 10.0
        let 예상총액 = 500000.0
        
        // When
        var 결과: Double?
        calculator.calculateTotalPrice(averagePrice: 평균단가, quantity: 수량)
            .subscribe(onNext: { total in
                결과 = total
            })
            .disposed(by: disposeBag)
        
        // Then
        #expect(결과 == 예상총액)
    }
    
    @Test func 수량계산_계산한값반환() {
        
        // Given
        let 평균단가 = 50000.0
        let 총액 = 500000.0
        let 예상수량 = 10.0
        
        // When
        var 결과: Double?
        calculator.calculateQuantity(averagePrice: 평균단가, totalPrice: 총액)
            .subscribe(onNext: { quantity in
                결과 = quantity
            })
            .disposed(by: disposeBag)
        
        // Then
        #expect(결과 == 예상수량)
    }
    

    @Test func 최종계산_계산한값반환() {
        
        // Given
        let 보유단가 = 50000.0
        let 보유수량 = 10.0
        let 추가단가 = 45000.0
        let 추가수량 = 10.0
        
        let 예상평균단가 = 47500.0
        let 예상수량 = 20.0
        let 예상총액 = 950000.0
        
        // When
        var 결과평균단가: Double?
        var 결과수량: Double?
        var 결과총액: Double?
        
        calculator.calculateFinal(
            holdingAveragePrice: 보유단가,
            holdingQuantity: 보유수량,
            additionalAveragePrice: 추가단가,
            additionalQuantity: 추가수량
        )
        .subscribe(onNext: { result in
            결과평균단가 = result.averagePrice
            결과수량 = result.quantity
            결과총액 = result.totalPrice
        })
        .disposed(by: disposeBag)
        
        // Then
        #expect(결과평균단가 == 예상평균단가)
        #expect(결과수량 == 예상수량)
        #expect(결과총액 == 예상총액)
    }
    
}
