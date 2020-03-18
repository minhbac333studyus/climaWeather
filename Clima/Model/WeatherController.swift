//
//  WeatherController.swift
//  Clima
//
//  Created by Adam  on 3/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func weatherDidUpdated(weatherControllerInput: WeatherController,weather: WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherController {
    // về cơ bản, lấy dũ liệu từ WeatherData -> bỏ vaò trong WeatherModel -> từ đó VIewController sẽ lấy kết qủa của model và xuất ra màn hình
    let WeatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=9a993f2df334df51c463af92fdbf8be0&units=metric"
    func fetchWeather(cityName: String) {
        let newCityName = cityName.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(WeatherUrl)&q=\(newCityName)"
        self.performRequest(urlString: urlString)
        print (urlString)
        
    }
    func fetchWeather(latitude:CLLocationDegrees, longtidue:CLLocationDegrees) {
           let urlString = "\(WeatherUrl)&lat=\(latitude)&lon=\(longtidue)"
           self.performRequest(urlString: urlString)
           print (urlString)
    }
    
    var delegate: WeatherManagerDelegate?
    
    //Now do the networking connect to Web Server to get data
    //    1.create URL
    //    2.Create URL session
    //    3. Give the session atask
    //    4. Start the task
    func performRequest(urlString: String)
    {
        //    1.create URL
        if let url = URL (string: urlString){
            //    2.Create URL session
            let session = URLSession( configuration: .default)
            //    3. Give the session a task
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            //    4. Start the task
            task.resume()
        }
    }
    func handle(data:  Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            self.delegate?.didFailWithError(error: error!)
            return
        }
        if let safeData = data {
            if let weatherSafeOject =  self.parseJSON(safeData)
           {
            self.delegate?.weatherDidUpdated(weatherControllerInput: self,weather: weatherSafeOject)
            }
        }
    }
    func parseJSON (_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from:weatherData)
            let idInput = decodedData.weather[0].id
            let nameIp  = decodedData.name
            let temperatureIp = decodedData.main.temp
            let maxTempIp = decodedData.main.temp_max
            let minTempIp = decodedData.main.temp_min
            let descriptionIp = decodedData.weather[0].description
            let weatherObject =  WeatherModel(conditionID: idInput, cityName: nameIp, temperature: temperatureIp, descriptionLabel: descriptionIp, tempMinLb: minTempIp, tempMaxLb: maxTempIp)
            print( weatherObject.conditionName)
            print(weatherObject.cityName)
           
            return weatherObject
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}

