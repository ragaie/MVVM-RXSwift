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



class HomeScreen: UIViewController {
    @IBOutlet weak var showSearchScreen: UIButton!
    
    @IBOutlet weak var tablemainScreen: UITableView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        showSearchScreen.rx.tap.subscribe(onNext: { [weak self]() in
            let vc : SearchScreen = (self?.storyboard?.instantiateViewController(identifier: "SearchScreenID"))!
            
            vc.selectedCity.subscribe(onNext: { (model) in
                

                let vc : DetailScreen = (self?.storyboard?.instantiateViewController(identifier: "detailScreenID"))!
                vc.model = model
                self?.present(vc, animated: true, completion: nil)
                
            }).disposed(by: self!.disposeBag)
            self?.present(vc, animated: true, completion: nil)
                       
        }).disposed(by: disposeBag)
    }


}

//http://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

//http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=2aa3ec79aa77894f9e0f127db16bcb25

//calling for several ids
//http://api.openweathermap.org/data/2.5/group?id=524901,703448,2643743&appid={API key}
