//
//  DetailScreenViewModel.swift
//  ParentTest
//
//  Created by Ragaie Alfy on 10/29/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa


protocol DetailScreenProtocal {
    

       func retriveData(id : Int)
        var weatherSubject : PublishSubject <WeatherResult>{ get  }
        var loadingSubject : BehaviorRelay <Bool>{get}

    

}

class DetailScreenViewModel: NSObject, DetailScreenProtocal{
    var weatherSubject: PublishSubject<WeatherResult>
    
    var loadingSubject: BehaviorRelay<Bool>
    
    
    
    private let disposeBag = DisposeBag()

    override init() {
        weatherSubject = PublishSubject <WeatherResult>()
        loadingSubject = BehaviorRelay <Bool>(value: true)
        
    }
    
    func retriveData(id : Int){
        loadingSubject.accept(true)
        let urlStr = "http://api.openweathermap.org/data/2.5/weather?id=\(id)&appid=2aa3ec79aa77894f9e0f127db16bcb25"
        let result : Observable<WeatherResult> = APIServicelayer.shared.send(apiurl: urlStr, way: RequestType.GET)
        
        result.subscribe(onNext: { (model) in
            self.loadingSubject.accept(false)

            self.weatherSubject.onNext(model)
            
            }).disposed(by: disposeBag)
       
    }
    
    

    
}
