//
//  Constants.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 07.12.2022.
//

import Foundation

let defaultCities = ["Warsaw","Bucharest","Minsk"] //,"Martuni","Shah Alam","Karmie","Budapest","Munich","Netivot","Santa Cruz de la Sierra"],"Porto Alegre","Kfar Yona","Palermo","Bremen","Jermuk","Beit Shemesh","Florence","Utrecht","Buenos Aires","Guayaquil","Rosario","Soledad","Subang Jaya","Valencia","Pasir Gudang","Akhtala"]

let openWeatherMapAPIKey = "7ab137f9295d4c0489e4008bf490451e"

enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}

func dtToHour(dt: Int, format: String) -> String {
    let day = Date(timeIntervalSince1970: TimeInterval(dt))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: day)
}
