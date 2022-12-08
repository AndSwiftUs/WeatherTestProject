//
//  OpenWeatherMap.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 07.12.2022.
//

import Foundation

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
    
    func weatherTemperaturePicture(name: String) async throws -> (Int, String) {
        
        return (-10, "10n")
        
        let queryItems = [
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: openWeatherMapAPIKey)
        ]
                
        guard let request = createRequest(queryItems) else { throw NetworkError.badURL }
        
        debugPrint(request)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        debugPrint(data)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw NetworkError.noData }
        guard (200 ... 299) ~= statusCode else { throw NetworkError.noData }
        
        guard let jsonData = try? JSONDecoder().decode(CurrentWeather.self, from: data) else { throw NetworkError.decodingError }
        
        debugPrint(jsonData)
        
        return (lround(jsonData.main?.temp ?? 0), (jsonData.weather?.first?.icon ?? "bad icon"))
    }
}

/* https://api.openweathermap.org/data/2.5/weather?q=London&appid={API key}

{
"coord": {
  "lon": -0.13,
  "lat": 51.51
},
"weather": [
  {
    "id": 300,
    "main": "Drizzle",
    "description": "light intensity drizzle",
    "icon": "09d"
  }
],
"base": "stations",
"main": {
  "temp": 280.32,
  "pressure": 1012,
  "humidity": 81,
  "temp_min": 279.15,
  "temp_max": 281.15
},
"visibility": 10000,
"wind": {
  "speed": 4.1,
  "deg": 80
},
"clouds": {
  "all": 90
},
"dt": 1485789600,
"sys": {
  "type": 1,
  "id": 5091,
  "message": 0.0103,
  "country": "GB",
  "sunrise": 1485762037,
  "sunset": 1485794875
},
"id": 2643743,
"name": "London",
"cod": 200
}
*/

