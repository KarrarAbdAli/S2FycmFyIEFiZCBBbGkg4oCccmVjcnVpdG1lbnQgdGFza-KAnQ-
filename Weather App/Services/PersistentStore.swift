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
    func delteObject(withid id:Int, completion: @escaping (Result<Bool,Error>) -> Void)
    func updateObject(withid id:Int, newData: WeatherObject, completion: @escaping (Result<Bool,Error>) -> Void)
}

class PersistentStore: Persistent{
    
    func updateObject(withid id: Int, newData: WeatherObject, completion: @escaping (Result<Bool, Error>) -> Void) {
        let req = NSFetchRequest<WeatherObjectCD>(entityName: "WeatherObjectCD")
        req.predicate = NSPredicate(format: "id==\(id)")
        var result = try? self.getContext().fetch(req)
        guard result != nil else {
            completion(.failure(PersistentContainerError.failToUpdateData))
            return
        }
        result![0] = modelToCoreDataObjectConverter(weatherObject: newData)
        saveContext()
        completion(.success(true))
    }
    
    func delteObject(withid id: Int, completion: @escaping (Result<Bool,Error>) -> Void) {
        let context = getContext()
        let req = NSFetchRequest<WeatherObjectCD>(entityName: "WeatherObjectCD")
        req.predicate = NSPredicate(format: "id==\(id)")
        if let result = try? context.fetch(req) {
            context.delete(result[0])
            saveContext()
            completion(.success(true))
        } else {
            completion(.failure(PersistentContainerError.unableToDeleteItemWithTheSpecifiedId))
        }
    }
    
    func loadData(completion: @escaping (Result<[WeatherObject],Error>) -> Void) {
        let req = NSFetchRequest<WeatherObjectCD>(entityName: "WeatherObjectCD")
        do {
            let weatherCD = try getContext().fetch(req)
            let weather = coreDataToModelObjectConverter(cd: weatherCD)
            completion(.success(weather))
        } catch {
            completion(.failure(PersistentContainerError.failToLoadData))
        }
    }
    
    func save(weatherObject: WeatherObject) {
        _ = modelToCoreDataObjectConverter(weatherObject: weatherObject)
        saveContext()
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
    private func coreDataToModelObjectConverter(cd: [WeatherObjectCD]) -> [WeatherObject] {
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
    
    private func modelToCoreDataObjectConverter(weatherObject: WeatherObject) -> WeatherObjectCD {
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
        if let wind = weatherObject.wind {
            windCD.speed = wind.speed
            if let deg = wind.deg {
                windCD.deg = Int32(deg)
            }
            objc.wind = windCD
        }
        
        let cloudsCD = CloudsCD(context: context)
        if let clouds = weatherObject.clouds {
            cloudsCD.all = Int32(clouds.all)
            objc.clouds = cloudsCD
        }
        
        
        let coordCD = CoordCD(context: context)
        if let coord = weatherObject.coord {
            coordCD.lat = coord.lat
            coordCD.lon = coord.lon
        }
        objc.coord = coordCD
        
        let mainCD = MainCD(context: context)
        let main = weatherObject.main
        mainCD.humidity = Int32(main.humidity)
        mainCD.pressure = Int32(main.pressure)
        mainCD.feelsLike = main.feelsLike ?? main.temp
        mainCD.temp = main.temp
        mainCD.tempMax = main.tempMax
        mainCD.tempMin = main.tempMin
        objc.main = mainCD
        
        
        
        let sysCD = SysCD(context: context)
        if let sys = weatherObject.sys {
            sysCD.country = sys.country
            sysCD.id = Int32(sys.id)
            sysCD.sunset = Int32(sys.sunset)
            sysCD.sunrise = Int32(sys.sunrise)
            sysCD.type = Int32(sys.type)
            if let message = sys.message {
                sysCD.message = message
            }
            objc.sys = sysCD
        }
        
        let weatherCD = WeatherCD(context: context)
        if let weather = weatherObject.weather {
            weatherCD.icon = weather[0].icon
            weatherCD.id = Int32(weather[0].id)
            weatherCD.main = weather[0].main
            weatherCD.weatherDescription = weather[0].weatherDescription
            objc.weather = weatherCD
        } else {
            objc.weather = nil
        }
        return objc
    }
}


enum PersistentContainerError: Error {
    case unableToDeleteItemWithTheSpecifiedId
    case failToLoadData
    case failToUpdateData
}
