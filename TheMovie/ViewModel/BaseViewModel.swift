//
//  BaseViewModel.swift
//  TheMovie
//
//  Created by nicolas castello on 26/08/2022.
//

import Foundation

class BaseViewModel {
    let service: AlamofireWebService
    let callApi: TheMovieApiRepository
    
    init() {
        self.service = AlamofireWebService()
        self.callApi = TheMovieApiRepository(webService: service)
    }
    
    func getImageBy(url: String, completion:@escaping(Data) -> Void) {
        callApi.getDataForImage(url: url, completion: { result in
            switch result {
            case .success(let imageData):
                completion(imageData)
            case .failure(let error):
                ShowErrorManager.showErrorView(title: "Ups".localized(), description: "genericError".localized())
            }
        })
    }
}
