//
//  SportObjectListPresenter.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import CoreLocation
import IronSource

protocol ISportObjectListPresenter: AnyObject {
    func checkLocation()
    func attachView(view: ISportObjectListView)
    func sportObjectWasSelect(sportObject: SportObject)
}

protocol ISportObjectListView: AnyObject {
    func showLocationState(isAllowed: Bool)
    func showObjects(sportsObjects: [SportObject])
    func showAdd(completionHandler: @escaping () -> Void)
    func routeToCreateReminder(sportObject: SportObject)
    func showError(text: String)
}

class SportObjectListPresenter: ISportObjectListPresenter, DeviceLocationServiceDelegate {
    
    private var currentLocation: CLLocationCoordinate2D?
    private let locationService: IDeviceLocationService
    private let databaseService: IDatabaseService
    private let settingsService: ISensentiveInfoService
    private let networkService: INetworkService
    private var wasStartLoading: Bool = false
    private let sportType: SportType
    private weak var view: ISportObjectListView?
    
    init(
        locationService: IDeviceLocationService,
        databaseService: IDatabaseService,
        networkService: INetworkService,
        settingsService: ISensentiveInfoService,
        sportType: SportType
    ) {
        self.databaseService = databaseService
        self.locationService = locationService
        self.sportType = sportType
        self.networkService = networkService
        self.settingsService = settingsService
    }
    
    func checkLocation() {
        locationService.requestLocationUpdates()
        if locationService.locationStatus == .denied {
            view?.showLocationState(isAllowed: false)
        } else {
            view?.showLocationState(isAllowed: true)
            self.currentLocation = locationService.currentLocation
        }
    }
    
    func attachView(view: ISportObjectListView) {
        self.view = view
        self.locationService.delegate = self
    }
    
    func loacationDidChange(location: CLLocationCoordinate2D?) {
        guard
            !wasStartLoading,
            let long = location?.longitude,
            let lat = location?.latitude
        else { return }
        loadObjects(long: long, lat: lat)
    }
    
    func sportObjectWasSelect(sportObject: SportObject) {
        guard
            !settingsService.isPremiumActive() // Олпачена ли подписка
        else {
            view?.routeToCreateReminder(sportObject: sportObject)
            return
        }
        // Проверяем на доступность видео
        if IronSource.hasRewardedVideo() {
            view?.showAdd {
                self.view?.routeToCreateReminder(sportObject: sportObject)
            }
        } else {
            view?.routeToCreateReminder(sportObject: sportObject)
        }
    }
    
    private func loadObjects(long: Double, lat: Double) {
        wasStartLoading = true
        print("lat: \(lat), long: \(long)")
        networkService.searchSportObjects(lat: lat,
                                          long: long,
                                          categoriesParams: sportType.networkParameter) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let models):
                let objects =  models.map({SportObject(type: strongSelf.sportType, name: $0.objectName, address: $0.address)})
                DispatchQueue.main.async {
                    strongSelf.view?.showObjects(sportsObjects: objects)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    strongSelf.view?.showError(text: error.textToDisplay)
                }
            }
        }
    }
    
    func didChangeLocationStatus() {
        guard locationService.locationStatus != nil else { return }
        checkLocation()
    }
}
