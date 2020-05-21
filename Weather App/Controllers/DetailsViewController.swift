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
        view.insertSubview(UIImageView(image: UIImage(named: "Background")), at: 0)
        cityLabel.text = weatherObject.name
        weatherDescriptionLabel.text = weatherObject.weather[0].weatherDescription
        print(weatherObject.weather[0].weatherDescription)
        degreeLabel.text = ((status == .c) ? String(ConversionService.getTempretureInC(weatherObject.main.temp)) : String(ConversionService.getTempretureInF(weatherObject.main.temp)))
    }
    
}
