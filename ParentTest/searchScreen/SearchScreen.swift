//
//  SearchScreen.swift
//  ParentTest
//
//  Created by Ragaie Alfy on 10/29/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
//cell id   ->cellSearchID
// view controller id   ---> SearchScreenID
class SearchScreen: UIViewController {
    
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loaderActivity: UIActivityIndicatorView!
    @IBOutlet weak var dismissScreen: UIButton!
    
    var selectedCity : PublishRelay<CityListModel> = PublishRelay<CityListModel>()
    
    var viewModel : CitySearchDataSource?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // selectedCity = PublishRelay<CityListModel>()
        viewModel = SearchScreenViewModel()
        configureBinding()
        // Do any additional setup after loading the view.
    }
    
    func configureBinding(){
        
        viewModel?.loadingSubject.bind(to: loaderActivity.rx.isAnimating).disposed(by: disposeBag)
        
        let searchQuery = searchBar.rx.text.orEmpty.asObservable()
        viewModel?.searchCityWithName(withName: searchQuery)
        viewModel?.getCitiesList()
        
        viewModel?.cityListSubject.bind(to: searchResultTableView.rx.items(cellIdentifier: "cellSearchID")){
            (index, model: CityListModel, cell) in
            cell.textLabel?.text = model.name
        }.disposed(by: disposeBag)
        
        dismissScreen.rx.tap.subscribe(onNext: { () in
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        searchResultTableView.rx.modelSelected(CityListModel.self).subscribe(onNext: { [weak self ] model in
            self?.dismiss(animated: true, completion: nil)
            self?.selectedCity.accept(model)
            print(model)
        }).disposed(by: disposeBag)
        
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
