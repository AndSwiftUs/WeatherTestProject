//
//  WorldTime.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 07.12.2022.
//

import Foundation
import SwiftUI

struct NinjaWorldTime: Decodable {
    
    var timezone  : String? = nil
    var datetime  : String? = nil
    var date      : String? = nil
    var year      : String? = nil
    var month     : String? = nil
    var day       : String? = nil
    var hour      : String? = nil
    var minute    : String? = nil
    var second    : String? = nil
    var dayOfWeek : String? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case timezone  = "timezone"
        case datetime  = "datetime"
        case date      = "date"
        case year      = "year"
        case month     = "month"
        case day       = "day"
        case hour      = "hour"
        case minute    = "minute"
        case second    = "second"
        case dayOfWeek = "day_of_week"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        timezone  = try values.decodeIfPresent(String.self , forKey: .timezone  )
        datetime  = try values.decodeIfPresent(String.self , forKey: .datetime  )
        date      = try values.decodeIfPresent(String.self , forKey: .date      )
        year      = try values.decodeIfPresent(String.self , forKey: .year      )
        month     = try values.decodeIfPresent(String.self , forKey: .month     )
        day       = try values.decodeIfPresent(String.self , forKey: .day       )
        hour      = try values.decodeIfPresent(String.self , forKey: .hour      )
        minute    = try values.decodeIfPresent(String.self , forKey: .minute    )
        second    = try values.decodeIfPresent(String.self , forKey: .second    )
        dayOfWeek = try values.decodeIfPresent(String.self , forKey: .dayOfWeek )
        
    }
    
    init() { }
    
}

class NinjaWorldTimeAPI: ObservableObject {
    
    private var commonComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.api-ninjas.com"
        components.path = "/v1/worldtime"
        
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
    
    func whatTimeInCity(name: String) async throws -> String {
        
//        return "12:20"
        
        var time = "unknown"
        
        let queryItems = [URLQueryItem(name: "city", value: name)]
        
        debugPrint(#function, queryItems)
        
        guard var request = createRequest(queryItems) else { throw URLError(.badURL) }
        
        request.setValue(ninjaAPIKey, forHTTPHeaderField: "X-Api-Key")
        
        debugPrint(#function, request)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw URLError(.badServerResponse) }
        guard (200 ... 299) ~= statusCode else { throw URLError(.cannotParseResponse) }
        
        debugPrint(#function, statusCode)
        
        let jsonNinjaWorldTime = try! JSONDecoder().decode(NinjaWorldTime.self, from: data)
        
        debugPrint(#function, jsonNinjaWorldTime)
        
        if (jsonNinjaWorldTime.hour != nil) {
            time = jsonNinjaWorldTime.hour! + ":" + jsonNinjaWorldTime.minute!
        }
        
        return time
    }
}
