//
//  SearchScreenViewModel.swift
//  ParentTest
//
//  Created by Ragaie Alfy on 10/29/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
protocol CitySearchDataSource {

    func searchCityWithName(withName name: Observable<String>)
    func getCitiesList()
    var cityListSubject : PublishSubject <[CityListModel]>{ get  }
    var loadingSubject : BehaviorRelay <Bool>{get}

}

class SearchScreenViewModel: NSObject, CitySearchDataSource {
   
    
    var cityListSubject: PublishSubject<[CityListModel]>
    
    var loadingSubject: BehaviorRelay<Bool>
    private var localCityList: [CityListModel]

    
    override init() {
        

        cityListSubject = PublishSubject<[CityListModel]>()
        loadingSubject = BehaviorRelay<Bool>(value: true)
        localCityList = []
        super.init()

    }
       private let disposeBag = DisposeBag()
    
    
      func searchCityWithName(withName name: Observable<String>) {
        self.loadingSubject.accept(true)

        name
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] searchQuery in
                self?.loadingSubject.accept(false)

                if searchQuery.isEmpty {
                    self?.cityListSubject.onNext([])
                } else {
                    self?.filterCityname(withCityName: searchQuery)
                }
            }).disposed(by: disposeBag)
    }

    private func filterCityname(withCityName cityName: String) {
        let foundItems = self.localCityList.filter { (($0.name?.range(of: cityName)) != nil) || $0.id == Int(cityName) }
        self.cityListSubject.onNext(foundItems)
    }
    
    func getCitiesList(){
  
        let data : Observable<[CityListModel]>  = load(resource: "cityList")
        self.loadingSubject.accept(true)

        data.subscribe(onNext: { (list) in
            self.cityListSubject.onNext(list)
            self.loadingSubject.accept(false)
            self.localCityList = list
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }, onDisposed: {
            
            }).disposed(by: disposeBag)
    }
    
    
    func load<T: Decodable>(resource: String) -> Observable<T> {
           return Observable<T>.create { observer in

               if let url = Bundle.main.url(forResource: resource, withExtension: "json") {
                   do {
                       let data = try Data(contentsOf: url)
                       let decoder = JSONDecoder()
                       let jsonData = try decoder.decode(T.self, from: data)
                       observer.on(.next(jsonData))
                       observer.on(.completed)
                   } catch {
                       print("error:\(error)")
                       observer.on(.error(error))
                   }
               }
               return Disposables.create()
           }
       }

}
