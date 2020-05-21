//
//  PersistentStore.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation
import CoreData

protocol Persistent {
    func save(weatherObject: WeatherObject)
    func loadData(completion: @escaping (Result<[WeatherObject],Error>) -> Void)
    func delteObject(withid id:Int)
}

class PersistentStore: Persistent{
    
    func delteObject(withid id: Int) {
        let context = getContext()
        let req = NSFetchRequest<WeatherObjectCD>(entityName: "WeatherObjectCD")
        req.predicate = NSPredicate(format: "id==\(id)")
        if let result = try? context.fetch(req) {
            for object in result {
                context.delete(object)
            }
            saveContext()
        }
    }
    
    
    func loadData(completion: @escaping (Result<[WeatherObject],Error>) -> Void) {
        let req = NSFetchRequest<WeatherObjectCD>(entityName: "WeatherObjectCD")
        do {
            let weatherCD = try getContext().fetch(req)
            let weather = cdToObjct(cd: weatherCD)
            completion(.success(weather))
        } catch {
            
        }
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Weather_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func save(weatherObject: WeatherObject) {
        let context = getContext()
        let objc = WeatherObjectCD(context: context)
        objc.base = weatherObject.base
        objc.cod = Int32(weatherObject.cod)
        objc.dt = Int32(weatherObject.dt)
        objc.id = Int32(weatherObject.id)
        objc.name = weatherObject.name
        objc.timezone = Int32(weatherObject.timezone)
        if let visibility = weatherObject.visibility {
            objc.visibility = Int32(visibility)
        }
        
        
        let windCD = WindCD(context: context)
        windCD.speed = weatherObject.wind.speed
        if let deg = weatherObject.wind.deg {
            windCD.deg = Int32(deg)
        }
        
        objc.wind = windCD
        
        let cloudsCD = CloudsCD(context: context)
        cloudsCD.all = Int32(weatherObject.clouds.all)
        objc.clouds = cloudsCD
        
        let coordCD = CoordCD(context: context)
        coordCD.lat = weatherObject.coord.lat
        coordCD.lon = weatherObject.coord.lon
        objc.coord = coordCD
        
        let mainCD = MainCD(context: context)
        mainCD.humidity = Int32(weatherObject.main.humidity)
        mainCD.pressure = Int32(weatherObject.main.pressure)
        mainCD.temp = weatherObject.main.temp
        mainCD.tempMax = weatherObject.main.tempMax
        mainCD.tempMin = weatherObject.main.tempMin
        objc.main = mainCD
        
        let sysCD = SysCD(context: context)
        sysCD.country = weatherObject.sys.country
        sysCD.id = Int32(weatherObject.sys.id)
        sysCD.sunset = Int32(weatherObject.sys.sunset)
        sysCD.sunrise = Int32(weatherObject.sys.sunrise)
        sysCD.type = Int32(weatherObject.sys.type)
        if let message = weatherObject.sys.message {
            sysCD.message = message
        }
        objc.sys = sysCD
        
        let weatherCD = WeatherCD(context: context)
        weatherCD.icon = weatherObject.weather[0].icon
        weatherCD.id = Int32(weatherObject.weather[0].id)
        weatherCD.main = weatherObject.weather[0].main
        weatherCD.weatherDescription = weatherObject.weather[0].weatherDescription
        objc.weather = weatherCD
        
        saveContext()
        

    }
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = getContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Helper methods and conversion
    private func cdToObjct(cd: [WeatherObjectCD]) -> [WeatherObject] {
        var weatherOBJ: [WeatherObject] = []
        cd.forEach{
            let obj = WeatherObject(base: $0.base!,
                                    visibility: Int($0.visibility),
                                    dt: Int($0.dt),
                                    id: Int($0.id),
                                    name: $0.name!,
                                    cod: Int($0.cod),
                                    coord: Coord(lon: $0.coord!.lon,
                                                 lat: $0.coord!.lat),
                                    weather: [Weather(id: Int($0.weather!.id),
                                                      main: $0.weather!.main!,
                                                      description: $0.weather!.weatherDescription!,
                                                      icon: $0.weather!.icon!)],
                                    main: Main(temp: $0.main!.temp,
                                               pressure: Int($0.main!.pressure),
                                               humidity: Int($0.main!.humidity),
                                               temp_min: $0.main!.tempMin,
                                               temp_max: $0.main!.tempMax,
                                               feelsLike: $0.main!.feelsLike),
                                    clouds: Clouds(all: Int($0.clouds!.all)),
                                    sys: Sys(type: Int($0.sys!.type),
                                             id: Int($0.sys!.id),
                                             country: $0.sys!.country!,
                                             sunrise: Int($0.sys!.sunrise),
                                             sunset: Int($0.sys!.sunset)),
                                    wind: Wind(speed: $0.wind!.speed,
                                               deg: Int($0.wind!.deg)),
                                    timezone: Int($0.timezone))
            weatherOBJ.append(obj)
        }
        return weatherOBJ
    }
    
    private func getContext() ->  NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
}
