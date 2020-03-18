//
//  weatherData.swift
//  Clima
//
//  Created by Adam  on 3/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
//Weather Data có trách nhiệm mã hoá Code từ internet, Yêu cầu tên của biến phải chính xác như trên Website APIs
struct WeatherData : Codable{
    let name: String
    let main: Main
    let weather: [Weather]// vì weather là1 array

}
//main{"temp": 280.32,"pressure": 1012,"humidity": 81,"temp_min": 279.15,"temp_max": 281.15}
//Vì Main là 1 object ,nên ta cần tạo 1 struct
struct Main:Codable { // có thể Decode and Encode
    let temp: Double
    let temp_min:Double
    let temp_max:Double
    
}
//Vì Weather là 1 Object ,nên ta cần tạo 1 struct
struct Weather:Codable {
    let description: String
    let id : Int
}
