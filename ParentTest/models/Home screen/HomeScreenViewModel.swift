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
    

       func retriveData(id : Int)
        var citiesWeatherSubject : PublishSubject <CityWeatherModel>{ get  }
        var loadingSubject : BehaviorRelay <Bool>{get}

    

}

class HomeScreenViewModel: NSObject ,HomeScreenProtocal{
    
    var citiesWeatherSubject: PublishSubject<CityWeatherModel>
       
       var loadingSubject: BehaviorRelay<Bool>
       
      private var localObject: CityWeatherModel = CityWeatherModel()

       
       private let disposeBag = DisposeBag()

       override init() {
           citiesWeatherSubject = PublishSubject <CityWeatherModel>()
           loadingSubject = BehaviorRelay <Bool>(value: true)
           
       }
    
    func addId(){
        
    }
    func removeId(){
        
    }
    func getCount(){
        
    }
      
    
    
       func retriveData(id : Int){
           loadingSubject.accept(true)
           let urlStr = "http://api.openweathermap.org/data/2.5/weather?id=\(id)&appid=2aa3ec79aa77894f9e0f127db16bcb25"
           let result : Observable<WeatherResult> = APIServicelayer.shared.send(apiurl: urlStr, way: RequestType.GET)
           
           result.subscribe(onNext: { (model) in
               self.loadingSubject.accept(false)

               //self.weatherSubject.onNext(model)
               
               }).disposed(by: disposeBag)
          
       }
       
}
