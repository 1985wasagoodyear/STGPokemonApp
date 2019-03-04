//
//  PokemonService.swift
//  PokemonApp
//
//  Created by Kevin Yu on 2/28/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

/*
 Singleton:
 Design pattern & anti-pattern
 
 Create one and only one instance of a class to use
 Useful for expensive classes & cases where you only want one instance at a time
 Trying to create another instance returns the singleton (in this example)
 
 App-wide, global, "global variable"
 Different accessors can affect each other
 
 In Swift:
 1. static instance for everyone to use
    -> static = can't subclass it
    -> don't need an instance to use; it returns the instance
 2. make init private
    -> cannot create another instance of it
 */

import Foundation

class PokemonService {
    static let shared = PokemonService()
    private let session: URLSession
    
    // in-memory cache to save completed requests
    private var requestCache = NSCache<NSString, NSData>()
    
    // in-memory cache to keep track of in-progress webservice calls
    // private var inProgressCalls = Set<String>()
    
    private init() {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession.init(configuration: config)
        
        // or just
        // session = URLSession.shared
    }
    
    // completion handler:
    // my body of work I want to perform
    // at a later, arbitrary time
    // "escape" the method; live past the method's destruction/lifespan
    // for closure parameters: nonescaping is the default
    // async needs escaping
    // closures are pass-by-reference
    func downloadPokemon(name: String,
                         completion: @escaping (Pokemon)->()) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/" + name
       // if inProgressCalls.contains(urlString) { return }
        
        if let value = requestCache.object(forKey: urlString as NSString) {
            let dat = Data(referencing: value)
            let decoder = JSONDecoder()
            do {
                // make a pokemon
                let pokemon = try decoder.decode(Pokemon.self, from: dat)
                // self.downloadPicture(for: pokemon, completion: completion)
                completion(pokemon)
            }
            catch {
                // error, something
                print(error)
            }
           // self.inProgressCalls.remove(urlString)
            return
        }
        
        guard let url = URL(string: urlString) else {
            // throw an error about invalid URL
            return
        }
        var request = URLRequest(url: url,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        // actual downloading/uploading task
        // inProgressCalls.insert(urlString)
        let dataTask = session.dataTask(with: request)
        { (data, response, error) in
            if let dat = data {
                self.requestCache.setObject(NSData(data: dat),
                                            forKey: urlString as NSString)
                // parse the data
                let decoder = JSONDecoder()
                do {
                    // make a pokemon
                    let pokemon = try decoder.decode(Pokemon.self, from: dat)
                    // self.downloadPicture(for: pokemon, completion: completion)
                    completion(pokemon)
                }
                catch {
                    // error, something
                    print(error)
                }
            }
            // self.inProgressCalls.remove(urlString)
        }
        dataTask.resume()
        
    }
    
    // one parameter is an escaping closure
    // it is some work that I will do
    // at an arbitrary point later
    // there is a function
    // with input: 1 Pokemon
    // and output: no output
    func downloadPicture(for pokemon: Pokemon,
                         completion: @escaping (Pokemon)->()) {
        let urlString = pokemon.randomImageURL
       // if inProgressCalls.contains(urlString) { return }
        
        // if the item exists in the NSCache, retrieve the item
        if let value = requestCache.object(forKey: urlString as NSString) {
            pokemon.image = Data(referencing: value)
            completion(pokemon)
            // self.inProgressCalls.remove(urlString)
            return
        }
        
        guard let url = URL(string: urlString) else {
            // error here
            return
        }
        
        print(url.relativeString) // will be printed only if we are fetching it from online
        
        // DataTasks require 2 parameters:
        // 1 - URL to download/upload from/to
        // 2 - work to do when done downloading/uploading
        // DataTask completion has
        // inProgressCalls.insert(urlString)
        let dataTaskComp: (Data?, URLResponse?, Error?)->() =
        { (data, _, _) in
            pokemon.image = data
            if let dat = data {
                self.requestCache.setObject(NSData(data: dat),
                                            forKey: urlString as NSString)
            }
            
            completion(pokemon)
            // self.inProgressCalls.remove(urlString)
        }
        
        let dataTask = session.dataTask(with: url,
                                        completionHandler: dataTaskComp)
        dataTask.resume()
    }
    
}
