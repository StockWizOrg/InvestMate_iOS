//
//  StockListViewController.swift
//  Presentation
//
//  Created by 조호근 on 12/29/24.
//

import UIKit
import Domain

import ReactorKit
import RxSwift

public final class StockListViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let calculator: StockCalculatorUseCase
    
    private let tableView = UITableView()
    private let emptyStateView = EmptyStateView()
    private let addButton = UIBarButtonItem()
    
    
    public init(reactor: StockListReactor, calculator: StockCalculatorUseCase) {
        self.calculator = calculator
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setUI()
        setLayout()
        
        DispatchQueue.main.async { [weak self] in
            self?.reactor?.action.onNext(.refresh)
        }
    }
    
    private func setStyle() {
        title = "보유 종목"
        
        tableView.register(StockCell.self, forCellReuseIdentifier: StockCell.identifier)
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        
        
        addButton.image = UIImage(systemName: "plus")
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setUI() {
        view.addSubviews(
            tableView,
            emptyStateView
        )
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showActionSheet(for stock: Stock) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let additionalPurchase = UIAlertAction(title: "추가 매수", style: .default) { [weak self] _ in
            self?.navigateToAdditionalPurchase(with: stock)
        }
        
        let edit = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            self?.navigateToEditStock(stock: stock)
        }
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.reactor?.action.onNext(.deleteStock(stock.id))
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [ edit, additionalPurchase, delete, cancel ].forEach { alert.addAction($0) }
        
        present(alert, animated: true)
    }

}

extension StockListViewController: ReactorView {
    
    public func bind(reactor: StockListReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: StockListReactor) {
        addButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigateToEditStock(stock: nil)
            })
            .disposed(by: disposeBag)
        
        emptyStateView.addButtonTap
            .subscribe(onNext: { [weak self] _ in
                self?.navigateToEditStock(stock: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: StockListReactor) {
        let stocks = reactor.state.map(\.stocks).share()
        
        stocks
            .bind(to: tableView.rx.items(cellIdentifier: StockCell.identifier, cellType: StockCell.self)) { _, stock, cell in
                
                cell.configure(with: stock)
                cell.menuButtonTap
                    .subscribe(onNext: { [weak self] stock in
                        print("Menu button tapped for stock:", stock)
                        self?.showActionSheet(for: stock)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        stocks
            .map { $0.isEmpty }
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
            
        stocks
            .map { !$0.isEmpty }
            .bind(to: emptyStateView.rx.isHidden)
            .disposed(by: disposeBag)
        
        stocks
            .subscribe(onNext: { updatedStocks in
                updatedStocks.debugLog(label: "Updated stocks")
            })
            .disposed(by: disposeBag)
    }
    
}

extension StockListViewController: StockListRefreshDelegate {
    
    public func refreshStockList() {
        reactor?.action.onNext(.refresh)
    }
    
    private func navigateToEditStock(stock: Stock?) {
        guard let reactor = reactor else { return }
        
        let mode: CreateStockReactor.Mode = stock.map { .edit($0) } ?? .create
        let createStockReactor = CreateStockReactor(
            stockManager: reactor.getStockManager(),
            calculator: calculator,
            mode: mode,
            refreshDelegate: self
        )
        
        let createStockVC = CreateStockViewController(reactor: createStockReactor,
                                                      mode: mode)
        navigationController?.pushViewController(createStockVC, animated: true)
    }
    
    private func navigateToAdditionalPurchase(with stock: Stock) {
        if let tabBarController = tabBarController,
           let navigationController = tabBarController.viewControllers?[0] as? UINavigationController,
           let additionalPurchaseVC = navigationController.viewControllers.first as? AdditionalPurchaseViewController {
            
            additionalPurchaseVC.reactor?.action.onNext(.setInitialStock(stock))
            
            tabBarController.selectedIndex = 0
        }
    }
    
}
