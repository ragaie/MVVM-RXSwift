//
//  APIServicelayer.swift
//  ParentTest
//
//  Created by Ragaie Alfy on 10/29/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


public enum RequestType: String {
    case GET, POST, PUT,DELETE
}
class APIServicelayer: NSObject {
    
    static var shared  = APIServicelayer()
    
    func send<T: Codable>(apiurl: String, way : RequestType ) -> Observable<T> {
           return Observable<T>.create { observer in
            let baseURL = URL(string: apiurl)!
            var request = URLRequest(url: baseURL)
            request.httpMethod = way.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Accept")
    
               let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                   do {
                       let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                       observer.onNext( model)
                   } catch let error {
                       observer.onError(error)
                   }
                   observer.onCompleted()
               }
               task.resume()
               
               return Disposables.create {
                   task.cancel()
               }
           }
       }
}
