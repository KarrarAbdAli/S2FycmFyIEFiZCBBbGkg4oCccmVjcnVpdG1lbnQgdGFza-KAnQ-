//
//  DetailsViewController.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var weatherObject: WeatherObject
    var status: degreeStatus
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var cloudsPercentageLabel: UILabel!
    @IBOutlet weak var logoMenuBottomView: UIView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    convenience init() {
        self.init()
    }
    
    init(weatherObject: WeatherObject, status: degreeStatus) {
        self.weatherObject = weatherObject
        self.status = status
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    // MARK: - helper methods
    func setupViews() {
        view.insertSubview(UIImageView(image: UIImage(named: "Background")), at: 0)
        logoMenuBottomView.layer.borderColor = UIColor.lightGray.cgColor
        logoMenuBottomView.layer.borderWidth = 0.5
        cityLabel.text = weatherObject.name
        if let weather = weatherObject.weather {
            weatherDescriptionLabel.text = weather[0].weatherDescription.capitalized
        } else {
            weatherDescriptionLabel.text = "No Description Avilable"
        }
        let main = weatherObject.main
        degreeLabel.text = getTempreture(forValue: main.temp)
        pressureLabel.text = "\(main.pressure) hPa"
        humidityLabel.text = "\(main.humidity)%"
        minTempLabel.text = getTempreture(forValue: main.tempMin)
        maxTempLabel.text = getTempreture(forValue: main.tempMax)
        if let feelsLikeTemp = main.feelsLike {
            feelsLikeLabel.text = getTempreture(forValue: feelsLikeTemp)
        } else {feelsLikeLabel.text = getTempreture(forValue: main.temp)}
        
        
        if let wind = weatherObject.wind {
            windSpeedLabel.text = "\(wind.speed) Km/hr"
        } else {
            windSpeedLabel.text = "Not Avilable data"
        }
        if let clouds = weatherObject.clouds {
            cloudsPercentageLabel.text = "\(clouds.all) %"
        } else {
            cloudsPercentageLabel.text = "Not Avilable data"
        }
        
        if let visibility = weatherObject.visibility  {
            visibilityLabel.text = "\(visibility/1000) Km"
        } else { visibilityLabel.text = "Data not Avilable" }
        
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoImageViewDidClick)))
        if let sys = weatherObject.sys {
            sunriseLabel.text = getDateObject(timeStamp: sys.sunrise)
            sunsetLabel.text = getDateObject(timeStamp: sys.sunset)
        }
        print(getDateObject(timeStamp: weatherObject.dt))
        
    }
    
    private func getTempreture(forValue value: Double) -> String {
        ((status == .c) ?
            String(ConversionService.getTempretureInC(value)) + "°" :
            String(ConversionService.getTempretureInF(value)) + "°")
    }
    
    @IBAction func listBackClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func logoImageViewDidClick(){
        if let url = URL(string: "https://openweathermap.org/") {
            UIApplication.shared.open(url)
        }
    }
    
    private func getDateObject(timeStamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timeStamp))
        var calendar = Calendar.current
        calendar.timeZone = .current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        return "\(hour):\(minutes):\(seconds)"
    }
}
