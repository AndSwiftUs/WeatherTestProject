//
//  GetWeatherImages.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 21.12.2022.
//

import SwiftUI

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
