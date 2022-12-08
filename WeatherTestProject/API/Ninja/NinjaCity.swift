//
//  City.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 07.12.2022.
//

import Foundation

struct NinjaCity: Codable {

  var name       : String? = nil
  var latitude   : Double? = nil
  var longitude  : Double? = nil
  var country    : String? = nil
  var population : Int?    = nil
  var isCapital  : Bool?   = nil

  enum CodingKeys: String, CodingKey {

    case name       = "name"
    case latitude   = "latitude"
    case longitude  = "longitude"
    case country    = "country"
    case population = "population"
    case isCapital  = "is_capital"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    name       = try values.decodeIfPresent(String.self , forKey: .name       )
    latitude   = try values.decodeIfPresent(Double.self , forKey: .latitude   )
    longitude  = try values.decodeIfPresent(Double.self , forKey: .longitude  )
    country    = try values.decodeIfPresent(String.self , forKey: .country    )
    population = try values.decodeIfPresent(Int.self    , forKey: .population )
    isCapital  = try values.decodeIfPresent(Bool.self   , forKey: .isCapital  )
 
  }

  init() { }

}

class NinjaCityApi: ObservableObject{
    @Published var city = NinjaCity()
    
    func loadData(completion:@escaping (String) -> ()) {
        let url = URL(string: "https://api.api-ninjas.com/v1/city?name=\(city)")!
        var request = URLRequest(url: url)
        request.setValue(ninjaAPIKey, forHTTPHeaderField: "X-Api-Key")
        URLSession.shared.dataTask(with: request) { data, response, error in
            let jsonNinjaCity = try! JSONDecoder().decode(NinjaCity.self, from: data!)
            let ll = String(jsonNinjaCity.latitude!) + ":" + String(jsonNinjaCity.longitude!)
            print(ll)
            DispatchQueue.main.async {
                completion(ll)
            }
        }.resume()
    }
}
