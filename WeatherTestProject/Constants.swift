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

func dtToHour(dt: Int, format: String) -> String {
    let day = Date(timeIntervalSince1970: TimeInterval(dt))
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_us")
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: day)
}

func imageFromIconB(icon: String) -> Image {
    switch icon {
    case "01d", "01n": return Image("IconWeather-1b")
    case "02d", "02n": return Image("IconWeather-2b")
    case "03d", "03n": return Image("IconWeather-3b")
    case "04d", "04n": return Image("IconWeather-7b")
    case "50d", "50n": return Image("IconWeather-5b")
    case "10d", "10n": return Image("IconWeather-4b")
    case "13d", "13n": return Image("IconWeather-6b")
        
    default:
        //        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"))
        return Image(systemName: "sos.circle")
    }
}

func imageFromIconA(icon: String) -> Image {
    switch icon {
    case "01d", "01n": return Image("IconWeather-1a")
    case "02d", "02n": return Image("IconWeather-2a")
    case "03d", "03n": return Image("IconWeather-3a")
    case "04d", "04n": return Image("IconWeather-7a")
    case "50d", "50n": return Image("IconWeather-5a")
    case "10d", "10n": return Image("IconWeather-4a")
    case "13d", "13n": return Image("IconWeather-6a")
        
    default:
        //        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"))
        return Image(systemName: "sos.circle")
    }
}

struct ExDivider: View {
    let color: Color = .white
    let width: CGFloat = 0.5
    let opacity: CGFloat = 0.3
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
            .opacity(opacity)
    }
}
