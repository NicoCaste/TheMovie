//
//  SearchViewModel.swift
//  TheMovie
//
//  Created by nicolas castello on 28/08/2022.
//

import Foundation
import UIKit

class SearchViewModel: BaseViewModel {
    private var searchTimer: Timer?
    private var timeInterval = 0.8
    
    func findMovieFor(title: String) {
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }

        searchTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(getArtist(_:)), userInfo: title, repeats: false)
    }
    
   @objc private func getArtist(_ timer: Timer) {
        guard let title: String = timer.userInfo as? String else { return }
       findMovies(text: title)
    }
    
    func findMovies(text: String) {
        let parameters = setQueryParameter(text: text)
        callApi.findMovies(parameters: parameters, completion: { result in
            switch result {
            case .success(let movieList):
                let userInfo: [String : Any] = [FoundMovies.foundMovie.rawValue : movieList]
                NotificationCenter.default.post(name: NSNotification.Name.foundMovies, object: nil, userInfo: userInfo)
            case .failure(_):
                ShowErrorManager.showErrorView(title: "Ups".localized(), description: "genericError".localized())
            }
        })
    }
    
    private func setQueryParameter(text: String) -> Parameters {
        let searchText = text.replacingOccurrences(of: " ", with: "+")
        return Parameters(query: searchText)
    }
}
