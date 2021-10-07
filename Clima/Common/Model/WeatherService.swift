//
//  WeatherService.swift
//  Clima
//
//  Created by Gus Adi on 26/09/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import Alamofire

class WeatherService {
    static let shared = WeatherService()
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1ac7735dd0985c3c8811a7ccefecbce4&units=metric"
    
    func performRequest(with urlString: String, completion: @escaping ((Result<WeatherData, AFError>) -> Void)) {
        AF.request(urlString, method: .get)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: WeatherData.self) { response in
                completion(response.result)
            }
    }
}
