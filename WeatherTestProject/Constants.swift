//
//  Constants.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 07.12.2022.
//

import SwiftUI

let defaultCities = ["My location", "Warsaw","Bucharest","Minsk","Budapest","Munich","Santa Cruz de la Sierra","Porto Alegre","Palermo","Bremen","Florence"]

let openWeatherMapAPIKey = "7ab137f9295d4c0489e4008bf490451e"

enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}
