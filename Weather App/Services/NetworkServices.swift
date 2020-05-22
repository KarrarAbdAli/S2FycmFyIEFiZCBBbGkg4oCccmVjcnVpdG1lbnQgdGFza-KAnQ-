//
//  FetchServices.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation

class NetworkServices {
    
    private let key = "8e032ed5e3a3bff36fcce6bc0145dc15"
    private let session = URLSession.shared
    
    func fetchWeatherData(city: String, completion: @escaping (Result<WeatherObject,Error>) -> Void){
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(key)")!
        var request = URLRequest(url: url)
               request.httpMethod = "GET"
        fetch(urlRequest: request, completion: completion)
    }
    
    func freeFetchAPICall(completion: @escaping (Result<WeatherObject,Error>) -> Void){
        var req = URLRequest(url: URL(string:"https://api.openweathermap.org/data/2.5/weather?q=London")!)
        req.httpMethod = "GET"
        fetch(urlRequest: req, completion: completion)
    }
    
    private func fetch(urlRequest: URLRequest, completion: @escaping (Result<WeatherObject,Error>) -> Void){
        session.dataTask(with: urlRequest) { (data, response, error) in
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



enum NetworkingErrors: Error {
    case networkErrorTaskError
    case jsonParsingError
}
