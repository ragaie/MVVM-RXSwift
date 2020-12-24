//
//  HomeScreenViewModel.swift
//  ParentTest
//
//  Created by Ragaie Alfy on 10/29/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
protocol HomeScreenProtocal {
    
    
    func retriveData(dataString : String)
    var citiesWeatherSubject : PublishSubject <[WeatherResult]>{ get  }
    var loadingSubject : BehaviorRelay <Bool>{get}
    var addNewCity : BehaviorRelay <Bool>{get}
    
    func retriveGroubData()
    func addCity(id : Int)
    func deleteObject(item :WeatherResult)
    
}

class HomeScreenViewModel: NSObject ,HomeScreenProtocal{
    
    var citiesWeatherSubject: PublishSubject<[WeatherResult]>
    
    var loadingSubject: BehaviorRelay<Bool>
    var addNewCity : BehaviorRelay <Bool>
    private var localObject: [WeatherResult] = []
    
    
    private let disposeBag = DisposeBag()
    
    override init() {
        citiesWeatherSubject = PublishSubject <[WeatherResult]>()
        loadingSubject = BehaviorRelay <Bool>(value: true)
        addNewCity =   BehaviorRelay <Bool>(value: false)
    }
    
    
    
    func addCity(id : Int){
        
        addNewItem(item:id)
        retriveGroubData()
        
    }
    
    func deleteObject(item :WeatherResult)
    {
        let newFilter = localObject.filter {
            
            
            $0.id != item.id
            
            
        }
        
        localObject = newFilter
        citiesWeatherSubject.onNext(newFilter)
        var str = ""
        for item in localObject{
            if item.id == localObject.first?.id{
                str = "\(item.id ?? 0)"
            }
            else{
                str = str + "," + "\(item.id ?? 0)"
            }
        }
        UserDefaults.standard.set(str, forKey: "CachedCities")
        
        // retriveGroubData()
        
        if localObject.count < 5 {
            addNewCity.accept(false)
        }
        
    }
    
    func retriveData(dataString : String){
        loadingSubject.accept(true)
        let urlStr = "http://api.openweathermap.org/data/2.5/weather?\(dataString)&appid=<you app id>"
        let result : Observable<WeatherResult> = APIServicelayer.shared.send(apiurl: urlStr, way: RequestType.GET)
        
        result.subscribe(onNext: { (model) in
            self.loadingSubject.accept(false)
            
            self.citiesWeatherSubject.onNext([model])
            self.localObject.append(model)
            //self.weatherSubject.onNext(model)
            
        }).disposed(by: disposeBag)
        
    }
    func retriveGroubData(){
        loadingSubject.accept(true)
        let urlStr = "http://api.openweathermap.org/data/2.5/group?id=\(getData())&appid=2aa3ec79aa77894f9e0f127db16bcb25"
        let result : Observable<CityWeatherModel> = APIServicelayer.shared.send(apiurl: urlStr, way: RequestType.GET)
        
        result.subscribe(onNext: { (model) in
            self.loadingSubject.accept(false)
            self.citiesWeatherSubject.onNext(model.list ?? [])
            self.localObject =  model.list ?? []
            //self.weatherSubject.onNext(model)
            if self.localObject.count > 4 {
                self.addNewCity.accept(true)
            }
        }).disposed(by: disposeBag)
        
    }
    
    
    func getData()->String{
        if let cached =  UserDefaults.standard.value(forKey: "CachedCities") {
            return cached as! String
        }
        else{
            return ""
        }
    }
    
    
    
    func addNewItem(item : Int){
        if let cached =  UserDefaults.standard.value(forKey: "CachedCities") {
            let str =  (cached as! String) + "," + "\(item)"
            UserDefaults.standard.set(str, forKey: "CachedCities")
        }
        else{
            UserDefaults.standard.set("\(item)", forKey: "CachedCities")
            
        }
        
    }
    
}
