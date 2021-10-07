//
//  WeatherPresenter.swift
//  Clima
//
//  Created by Gus Adi on 24/09/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import UIKit

protocol WeatherPresenterDelegate: NSObjectProtocol {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherPresenter {
    private let weatherService: WeatherService
    private var activityIndicator: UIActivityIndicatorView?
    private var indicatorBgView: UIView?
    weak private var weatherPresenterDelegate: WeatherPresenterDelegate?
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func setPresenterDelegate(presenterDelegate: WeatherPresenterDelegate?) {
        self.weatherPresenterDelegate = presenterDelegate
    }
    
    func setActivityIndicator(with activityIndicator: UIActivityIndicatorView) {
        self.activityIndicator = activityIndicator
    }
    
    func setIndicatorBg(with background: UIView) {
        self.indicatorBgView = background
    }
    
    func fetchWeather(cityName: String) {
        self.activityIndicator?.startAnimating()
        self.indicatorBgView?.isHidden = false
        
        let urlString = "\(weatherService.weatherURL)&q=\(cityName)"
		self.performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.activityIndicator?.startAnimating()
        self.indicatorBgView?.isHidden = false
        
        let urlString = "\(weatherService.weatherURL)&lat=\(latitude)&lon=\(longitude)"
		self.performRequest(with: urlString)
    }

	func performRequest(with url: String) {
		weatherService.performRequest(with: url) { result in
			switch result {
			case .success(let data) :
				let weathers = WeatherModel(conditionId: data.weather[0].id, cityName: data.name, temperature: data.main.temp)

				self.activityIndicator?.stopAnimating()
				self.indicatorBgView?.isHidden = true
				self.weatherPresenterDelegate?.didUpdateWeather(weather: weathers)
			case .failure(let error) :
				self.weatherPresenterDelegate?.didFailWithError(error: error)
			}
		}
	}
}
