//
//  FetchServices.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation

enum NetworkingErrors: Error {
    case networkErrorTaskError
    case jsonParsingError
}

class NetworkServices {
    
    private let key = "183fe529e238191c9e5187931d3fed0e" // use this key if the service calls stoped "8e032ed5e3a3bff36fcce6bc0145dc15"
    private let session = URLSession.shared
    
    func fetchWeatherData(city: String, completion: @escaping (Result<WeatherObject,Error>) -> Void){
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(key)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(NetworkingErrors.networkErrorTaskError))
            }
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        let weather = try JSONDecoder().decode(WeatherObject.self, from: data)
                        completion(.success(weather))
                    } catch let error{
                        print(error)
                        completion(.failure(NetworkingErrors.jsonParsingError))
                    }
                }
            }
        }.resume()
    }
}


