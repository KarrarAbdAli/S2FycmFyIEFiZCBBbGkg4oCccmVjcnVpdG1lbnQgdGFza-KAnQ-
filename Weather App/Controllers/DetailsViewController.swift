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
        cityLabel.text = weatherObject.name
        weatherDescriptionLabel.text = weatherObject.weather[0].weatherDescription
        degreeLabel.text = getTempreture(forValue: weatherObject.main.temp)
        
        windSpeedLabel.text = "\(weatherObject.wind.speed) Km/hr"
        feelsLikeLabel.text = getTempreture(forValue: weatherObject.main.feelsLike)

        pressureLabel.text = "\(weatherObject.main.pressure) hPa"
        humidityLabel.text = "\(weatherObject.main.humidity)%"
        minTempLabel.text = getTempreture(forValue: weatherObject.main.tempMin)
        maxTempLabel.text = getTempreture(forValue: weatherObject.main.tempMax)
        if let visibility = weatherObject.visibility  {
            visibilityLabel.text = "\(visibility/1000) Km"
        } else {
           visibilityLabel.text = "Data not Avilable"
        }
        
        cloudsPercentageLabel.text = "\(weatherObject.clouds.all) %"
        
    }
    private func getTempreture(forValue value: Double) -> String {
        
        ((status == .c) ? String(ConversionService.getTempretureInC(value)) + "°" : String(ConversionService.getTempretureInF(value)) + "°")
    }
    
    @IBAction func listBackClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
