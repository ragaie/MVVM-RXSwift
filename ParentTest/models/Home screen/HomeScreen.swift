//
//  ViewController.swift
//  ParentTest
//
//  Created by Ragaie Alfy on 10/29/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//

import UIKit

/// cell id --> cellID
import RxCocoa
import RxSwift
import CoreLocation

class HomeScreen: UIViewController {
    @IBOutlet weak var showSearchScreen: UIButton!
    
    @IBOutlet weak var tablemainScreen: UITableView!
    let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    var viewmodel : HomeScreenProtocal = HomeScreenViewModel()
    
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For use when the app is open
        locationManager.requestWhenInUseAuthorization()
        // If location services is enabled get the users location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // You can change the locaiton accuary here.
        locationManager.startUpdatingLocation()
        
        
        configurebinding()
        if thereIsOldData(){
            viewmodel.retriveGroubData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func configurebinding(){
        
        viewmodel.addNewCity.bind(to: showSearchScreen.rx.isHidden).disposed(by: disposeBag)
        viewmodel.citiesWeatherSubject.bind(to: tablemainScreen.rx.items(cellIdentifier: "cellID")){
            (index, model : WeatherResult,cell) in
            cell.textLabel?.text = model.name
            
        }.disposed(by: disposeBag)
        
        tablemainScreen.rx.modelSelected(WeatherResult.self).subscribe(onNext: { (model) in
            
            let vc : DetailScreen = (self.storyboard?.instantiateViewController(identifier: "detailScreenID"))!
            vc.cityid = model.id
            self.present(vc, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        
        tablemainScreen.rx.modelDeleted(WeatherResult.self).subscribe(onNext: { (model) in
            print(model)
            
            self.viewmodel.deleteObject(item: model)
        }).disposed(by: disposeBag)
        
        
        viewmodel.loadingSubject.bind(to: activityLoader.rx.isAnimating).disposed(by: disposeBag)
        showSearchScreen.rx.tap.subscribe(onNext: { [weak self]() in
            let vc : SearchScreen = (self?.storyboard?.instantiateViewController(identifier: "SearchScreenID"))!
            
            vc.selectedCity.subscribe(onNext: { (model) in
                
                self?.viewmodel.addCity(id: model.id ?? 0)
                let vc : DetailScreen = (self?.storyboard?.instantiateViewController(identifier: "detailScreenID"))!
                vc.cityid = model.id
                self?.present(vc, animated: true, completion: nil)
                
            }).disposed(by: self!.disposeBag)
            self?.present(vc, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
        
    }
    
    
    
    
}


extension HomeScreen:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            if !thereIsOldData(){
                viewmodel.retriveData(dataString: "lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)")
            }
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            print("location disappled")
            //get default city london
            //call data for London, UK
            if !thereIsOldData(){
                viewmodel.retriveData(dataString: "q=London,uk")
            }
        }
    }
}






extension HomeScreen{
    
    func thereIsOldData()->Bool{
        
        if let cached =  UserDefaults.standard.value(forKey: "CachedCities") as? String {
            if cached == ""{
                return false
            }
            return true
        }
        else{
            return false
        }
    }
    
    
    
    
}

//http://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

//http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=2aa3ec79aa77894f9e0f127db16bcb25

//calling for several ids
//http://api.openweathermap.org/data/2.5/group?id=524901,703448,2643743&appid={API key}
