//
//  FiveDayForecastAPI.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 08.12.2022.
//

import Foundation

@MainActor
class FiveDayForecastAPI: ObservableObject {
    
    @Published var buffer: [WList] = []
    
    private var commonComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast"
        
        return components
    }
    
    private func createRequest(_ queryItems: [URLQueryItem]) -> URLRequest? {
        var components = commonComponents
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    func reload(name: String) async throws {
        let queryItems = [
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: openWeatherMapAPIKey)
        ]
                
        guard let request = createRequest(queryItems) else { throw NetworkError.badURL }
        
        print(#function, "request:", request)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print(#function, "data:" ,data)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw NetworkError.noData }
        guard (200 ... 299) ~= statusCode else { throw NetworkError.noData }
        
        print("Prepeare to decode!")
        
        do {
            let jsonData = try JSONDecoder().decode(FiveDayForecastModel.self, from: data)
            
            print(#function, "jsonData", jsonData)
                        
            self.buffer = jsonData.buff!
            
        } catch {
            print(error)
            fatalError(error.localizedDescription)
        }
    }
    
    func hourForecast(name: String) async throws -> FiveDayForecastModel {
                
        let queryItems = [
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: openWeatherMapAPIKey)
        ]
                
        guard let request = createRequest(queryItems) else { throw NetworkError.badURL }
        
        print(#function, "request:", request)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print(#function, "data:" ,data)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw NetworkError.noData }
        guard (200 ... 299) ~= statusCode else { throw NetworkError.noData }
        
        print("Prepeare to decode!")
        
        do {
            let jsonData = try JSONDecoder().decode(FiveDayForecastModel.self, from: data)
            
            print(#function, "jsonData", jsonData)
            
            return jsonData
            
        } catch {
            print(error)
            fatalError(error.localizedDescription)
        }
  
    }
    
}
