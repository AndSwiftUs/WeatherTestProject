//
//  OpenWeatherMap.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 07.12.2022.
//

import Foundation

@MainActor
class CurrentWeatherDataAPI: ObservableObject {
    
    private var commonComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        
        return components
    }
    
    func createRequest(_ queryItems: [URLQueryItem]) -> URLRequest? {
        var components = commonComponents
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    func weatherTemperaturePictureTimeZone(name: String) async throws -> (Int, String, String) {
        
        // for develop and debug
        //        return (-10, "10n", "20:20")
        
        let queryItems = [
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: openWeatherMapAPIKey)
        ]
        
        guard let request = createRequest(queryItems) else { throw NetworkError.badURL }
        
        debugPrint(#function, "request: ", request)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        debugPrint(#function, name, data)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw NetworkError.noData }
        guard (200 ... 299) ~= statusCode else { throw NetworkError.noData }
        
        guard let jsonData = try? JSONDecoder().decode(CurrentWeatherModel.self, from: data) else { throw NetworkError.decodingError }
        
        //        debugPrint(#function, jsonData)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateWithTimeZone = Date.now.addingTimeInterval(Double(jsonData.timezone!))
        let theTime = dateFormatter.string(from: dateWithTimeZone)
        
        return (
            lround(jsonData.main?.temp ?? 0),
            jsonData.weather?.first?.icon ?? "bad icon",
            theTime
        )
    }
    
    func currentWeatherByName(name: String) async throws -> CurrentWeatherModel {
        
        let queryItems = [
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: openWeatherMapAPIKey)
        ]
        
        guard let request = createRequest(queryItems) else { throw NetworkError.badURL }
        
        //        debugPrint(#function, request)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        debugPrint(#function, name, data)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw NetworkError.noData }
        guard (200 ... 299) ~= statusCode else { throw NetworkError.noData }
        
        do {
            let jsonData = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
            
            //            print(#function, "jsonData", jsonData)
            
            return jsonData
            
        } catch {
            print(error)
            fatalError(error.localizedDescription)
        }
        
    }
    
    func currentWeatherByLocation(lat: String, lon: String) async throws -> CurrentWeatherModel {
        
        let queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: openWeatherMapAPIKey)
        ]
        
        guard let request = createRequest(queryItems) else { throw NetworkError.badURL }
        
        //        debugPrint(#function, request)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        debugPrint(#function, lat, lon, data)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw NetworkError.noData }
        guard (200 ... 299) ~= statusCode else { throw NetworkError.noData }
        
        do {
            let jsonData = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
            
            //            print(#function, "jsonData", jsonData)
            
            return jsonData
            
        } catch {
            print(error)
            fatalError(error.localizedDescription)
        }
        
    }
}

// https://api.openweathermap.org/data/2.5/weather?q=London&appid={API key}
