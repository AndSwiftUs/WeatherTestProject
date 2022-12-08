//
//  Weather.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 07.12.2022.
//

import Foundation

struct NinjaWeather: Decodable {
    
    var cloudPct    : Int?    = nil
    var temp        : Int?    = nil
    var feelsLike   : Int?    = nil
    var humidity    : Int?    = nil
    var minTemp     : Int?    = nil
    var maxTemp     : Int?    = nil
    var windSpeed   : Double? = nil
    var windDegrees : Int?    = nil
    var sunrise     : Int?    = nil
    var sunset      : Int?    = nil
    
    enum CodingKeys: String, CodingKey {
        
        case cloudPct    = "cloud_pct"
        case temp        = "temp"
        case feelsLike   = "feels_like"
        case humidity    = "humidity"
        case minTemp     = "min_temp"
        case maxTemp     = "max_temp"
        case windSpeed   = "wind_speed"
        case windDegrees = "wind_degrees"
        case sunrise     = "sunrise"
        case sunset      = "sunset"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        cloudPct    = try values.decodeIfPresent(Int.self    , forKey: .cloudPct    )
        temp        = try values.decodeIfPresent(Int.self    , forKey: .temp        )
        feelsLike   = try values.decodeIfPresent(Int.self    , forKey: .feelsLike   )
        humidity    = try values.decodeIfPresent(Int.self    , forKey: .humidity    )
        minTemp     = try values.decodeIfPresent(Int.self    , forKey: .minTemp     )
        maxTemp     = try values.decodeIfPresent(Int.self    , forKey: .maxTemp     )
        windSpeed   = try values.decodeIfPresent(Double.self , forKey: .windSpeed   )
        windDegrees = try values.decodeIfPresent(Int.self    , forKey: .windDegrees )
        sunrise     = try values.decodeIfPresent(Int.self    , forKey: .sunrise     )
        sunset      = try values.decodeIfPresent(Int.self    , forKey: .sunset      )
        
    }
    
    init() { }

}

class NinjaWeatherAPI: ObservableObject{
    
    private var commonComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.api-ninjas.com"
        components.path = "/v1/weather"
        
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
    
    func whatWeatherInCity(name: String) async throws -> (Int, String) {
        
        return (91, "-1")
        
        var picture = 0
        var temperature = "unknown"
        
        let queryItems = [URLQueryItem(name: "city", value: name)]
        guard var request = createRequest(queryItems) else { throw URLError(.badURL) }
        
        request.setValue(ninjaAPIKey, forHTTPHeaderField: "X-Api-Key")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw URLError(.badServerResponse) }
        guard (200 ... 299) ~= statusCode else { throw URLError(.cannotParseResponse) }
        
        guard let characters = String(data: data, encoding: .utf8) else { throw URLError(.cannotDecodeContentData) }
        debugPrint(characters)
        
        let jsonNinjaWeather = try! JSONDecoder().decode(NinjaWeather.self, from: data)
                
        if jsonNinjaWeather.cloudPct != nil {
            picture = jsonNinjaWeather.cloudPct!
        }
        
        if jsonNinjaWeather.temp != nil {
            temperature = String(jsonNinjaWeather.temp!)
        }
        return (picture, temperature)
    }
}
