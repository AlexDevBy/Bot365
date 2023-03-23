//
//  HomeScreenPresenter.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation

protocol IHomeScreenPresenter: AnyObject {
    func getSuggestions() -> [ICellShowable]
    func getCategories() -> [CategoriesModels]
    func attachView(view: IHomeView)
    func buyRemoveAdd()
}

protocol IHomeView: AnyObject {
    func showMessage(text: String)
    func showLoader()
    func hideLoader()
    func reloadSugesstions(types: [ICellShowable])
}

class HomeScreenPresenter: IHomeScreenPresenter {
    
    private let networkService: INetworkService
    private let userInfoService: ISensentiveInfoService
    private let presentationAssembly: IPresentationAssembly
    private let purchasesService: IProductService
    private let notificationCenter = NotificationCenter.default
    private weak var view: IHomeView?
    
    init(networkService: INetworkService,
         userInfoService: ISensentiveInfoService,
         presentationAssembly: IPresentationAssembly,
         productService: IProductService
    ) {
        self.networkService = networkService
        self.userInfoService = userInfoService
        self.presentationAssembly = presentationAssembly
        self.purchasesService = productService
    }
    
    func attachView(view: IHomeView) {
        self.view = view
        addNotification()
    }
    
    private func addNotification() {
        notificationCenter.addObserver(self,
                                       selector: #selector(reloadSuggestions),
                                       name: .addsOffSuccess,
                                       object: nil)
    }
    
    private func postNotification() {
        notificationCenter
            .post(
                name: .addsOffSuccess,
                object: nil
            )
    }
    
    @objc
    private func reloadSuggestions() {
        DispatchQueue.main.async {
            self.view?.reloadSugesstions(types: self.getSuggestions())
        }
    }
    
    func getSuggestions() -> [ICellShowable] {
        var dataSource = [
            SuggestionsModels(type: .football),
            SuggestionsModels(type: .basketball)
        ]
        
        if !userInfoService.isPremiumActive() {
            dataSource.insert(SuggestionsModels(type: .adds), at: 1)
        }
        return dataSource
    }
    
    func getCategories() -> [CategoriesModels] {
        return [
            CategoriesModels(type: .football),
            CategoriesModels(type: .running),
            CategoriesModels(type: .basketball),
            CategoriesModels(type: .volley),
            CategoriesModels(type: .swimming),
            CategoriesModels(type: .gymnastics),
            CategoriesModels(type: .martialsArt),
            CategoriesModels(type: .athletics),
            CategoriesModels(type: .pingPong),
            CategoriesModels(type: .ski),
            CategoriesModels(type: .yoga),
            CategoriesModels(type: .fitDance)
        ]
    }
    
    func buyRemoveAdd() {
        view?.showLoader()
        purchasesService.buyAddsOff { [ weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(_):
                    strongSelf.sendToSucceedPurchases()
                case .failure(let error):
                    self?.view?.hideLoader()
                    print(error)
                }
            }
        }
    }
    
    private func sendToSucceedPurchases() {
        networkService.addPremium { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                self?.view?.hideLoader()
                switch result {
                case .success(let succesResult):
                    if succesResult.0 {
                        strongSelf.userInfoService.savePremium()
                        strongSelf.view?.showMessage(text: succesResult.1)
                        strongSelf.postNotification()
                    } else {
                        strongSelf.view?.showMessage(text: succesResult.1)
                    }
                case .failure(let error):
                    strongSelf.view?.showMessage(text: error.localizedDescription)
                }
            }
        }
    }

    deinit {
        notificationCenter
            .removeObserver(self,
                            name: .addsOffSuccess,
                            object: nil
            )
    }
}
