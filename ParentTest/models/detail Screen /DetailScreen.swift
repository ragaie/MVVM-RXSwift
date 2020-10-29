//
//  DetailScreen.swift
//  ParentTest
//
//  Created by Ragaie Alfy on 10/29/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
//viewcontroller Id --->  detailScreenID
class DetailScreen: UIViewController {
    
    var cityid : Int?
    var viewModel : DetailScreenProtocal?
    private let disposeBag = DisposeBag()
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    @IBOutlet weak var resultlabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailScreenViewModel()
        
        if let  item = cityid
        {
            viewModel?.retriveData(id: item )
        }
        
        viewModel?.weatherSubject.observeOn(MainScheduler.instance).subscribe(onNext: { (result) in
            self.resultlabel.text = result.name
            
            
            do {
                let JSON = try JSONEncoder().encode(result)
                self.resultlabel.text = String.init(data: JSON, encoding: .nonLossyASCII)
            } catch let _ {
            }
            
            //you can add more information as you need based you design rrequirement.
        }).disposed(by: disposeBag)
        
        viewModel?.loadingSubject.bind(to: activityMonitor.rx.isAnimating).disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
