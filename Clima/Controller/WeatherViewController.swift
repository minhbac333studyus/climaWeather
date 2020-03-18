//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
//API keys :9a993f2df334df51c463af92fdbf8be0
import CoreLocation
class WeatherViewController: UIViewController {
    
    // Nhìn số (1) , Kế thừa class UITextFieldDelegate
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func GPSPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var DescriptionLable: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    //Dùng UI Text Field to get input from keyboard on Iphone
    //Ở TexinputTrait thay đổi chế đôj chữ ( Capitalize) tự đông in hoa chữ cái đâù tiên
    
    
    var weatherControllerOj =  WeatherController()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
       
        weatherControllerOj.delegate = self // để Delegate của weatherMânger ko có giá trị NULL, lúc gọi hàm weatherDidUpdated mới thành công
        searchTextField.delegate = self //Hàm này trả về giá trị khi User nhập giá trị, và báo lại cho ViewController -> User vừa mới nhập/dừng input hoặc nhấp vào chỗ khác, t có nên deselect myself ko ?
        // (2)
        
    }
    
    
    
}
//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    
    //Tạo IBaction cho ICon Tìm kiếm
    @IBAction func searchPress(_ sender: UIButton) {
        searchTextField.endEditing(true)
        //Hàm endEditing(true) sẽ Ẩn bàn phím khi người dùng nhập nút tìm kiếm
        print(searchTextField.text!)
    }
    //Bây h sẽ làm điều tương tự với bàn phím ( có nút Tìm kiếm hoặc Return ). Nhưng không thể làm IBAction cho nút ở Keyboard đc
    //Vì thế dùng UItextFieldDelegate -> Class WeartherViewController sẽ kế thưa từ class UIViewController và UItextFieldDelegate.
    // (1)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Đây là hàm mặc định, có sẵn trong textFieldUIDelegate -> Giống IBAction nhưng cho nút Search ở trên bàn phím Iphone
        // Hỏi ViewController có nên chạy khi người dùng nhập data vào không
        //(3)
        searchTextField.endEditing(true)
        //Hàm endEditing(true) sẽ Ẩn bàn phím khi người dùng nhập nút tìm kiếm
        print(searchTextField.text!)
        return true
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Đây là hàm mặc định của UItexxtField, báo lại với UIViewController-> User ĐÃ nhập xong dữ liệu trong TextBox rồi , Bây h làm gì tiếp theo
        //Ta muốn dòng chữ sẽ biến mất, để lần nhập tiếp theo tiện hơn
        //(4)
        if let city = searchTextField.text {
            weatherControllerOj.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
        //Bây giờ sử dụng SearchTextField.text để có được thông tin Thành Phố Cần Kiểm tra Thời Tiết
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //Hàm Mặc định có sẵn trong UIDelegate, báo lại với UIViewController -> Úser vừa nhập xong rồi, check "Validation"
        //Ta cũng muốn ghi cảnh báo nếu User ko nhập chữ nào cả nhưng vẫn nhấp Search.  **
        //(5)
        if textField.text != ""
        {
            return true
        } else {
            //Placeholder là dòng chữ mặc đinh trong textBox khi ngừoi dùng chưa nhập ( mặc định chữ Search) và Khi nhập xong -> Biến mất or Cảnh báo
            textField.placeholder = "Please type some input"
            return false
        }
    }
    
    //khi nhấp vào icon Lookup -> Tìm và in thông tin
}
//MARK: - WeatherManagerController
extension WeatherViewController: WeatherManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    func weatherDidUpdated(weatherControllerInput  :WeatherController ,weather: WeatherModel) {
        print(weather.temperature1Decinal)
        /// Hàm này sẽ in kêts quả ra màn
        // có  2 agrument là WeatherModel <- Lấy thông tin từ Internet và đã đc mã hoá qua Weather Controller
        // Từ Weather Controller -> lấy thông tin đã mã hoá và xuất ra màn hình đt
        DispatchQueue.main.async { self.temperatureLabel.text = weather.temperature1Decinal}
        DispatchQueue.main.async {self.conditionImageView.image = UIImage(systemName: weather.conditionName)}
        DispatchQueue.main.async {self.cityLabel.text = weather.cityName}
        DispatchQueue.main.async {self.DescriptionLable.text = weather.descriptionLabel    }
        DispatchQueue.main.async {self.minTempLabel.text = String(weather.tempMinLb)    }
        DispatchQueue.main.async {self.maxTempLabel.text = String(weather.tempMaxLb)    }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if  let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherControllerOj.fetchWeather(latitude: lat ,longtidue: lon)
            //Hàm GPS , cũng chỉnh sủa trong ìnfo.plist-> giải thích lí do vì sao cần GPS
        }
    
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
    }
}
