public func calculateFinal(
    holdingAveragePrice: Double,
    holdingQuantity: Double,
    additionalAveragePrice: Double,
    additionalQuantity: Double
) -> Observable<(averagePrice: Double, quantity: Double, totalPrice: Double)> {
    // 모든 값을 소수점 2자리까지 유지
    let finalQuantity = (holdingQuantity + additionalQuantity).rounded(toPlaces: 2)
    
    let holdingTotal = holdingAveragePrice * holdingQuantity
    let additionalTotal = additionalAveragePrice * additionalQuantity
    let finalTotalPrice = (holdingTotal + additionalTotal).rounded(toPlaces: 2)
    
    let finalAveragePrice = (finalTotalPrice / finalQuantity).rounded(toPlaces: 2)
    
    return .just((finalAveragePrice, finalQuantity, finalTotalPrice))
}
