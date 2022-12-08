
import Foundation

struct Wind: Codable {

  var speed : Double? = nil
  var deg   : Int?    = nil

  enum CodingKeys: String, CodingKey {

    case speed = "speed"
    case deg   = "deg"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    speed = try values.decodeIfPresent(Double.self , forKey: .speed )
    deg   = try values.decodeIfPresent(Int.self    , forKey: .deg   )
 
  }

  init() {

  }

}