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
        guard let url = URL(string: urlString) else {
            // throw an error about invalid URL
            return
        }
        var request = URLRequest(url: url,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        // actual downloading/uploading task
        let dataTask = session.dataTask(with: request)
        { (data, response, error) in
            if let dat = data {
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
        }
        dataTask.resume()
        
    }
    
    // one parameter is an escaping closure
    // it is some work that I will do
    // at an arbitrary point later
    // there is a function
    // with input: 1 Pokemone
    // and output: no output
    func downloadPicture(for pokemon: Pokemon,
                         completion: @escaping (Pokemon)->()) {
        
        guard let url = URL(string: pokemon.randomImageURL) else {
            // error here
            return
        }
        print(url.relativeString)
        
        // DataTasks require 2 parameters:
        // 1 - URL to download/upload from/to
        // 2 - work to do when done downloading/uploading
        // DataTask completion has
        let dataTaskComp: (Data?, URLResponse?, Error?)->() =
        { (data, _, _) in
            pokemon.image = data
            completion(pokemon)
        }
        
        let dataTask = session.dataTask(with: url,
                                        completionHandler: dataTaskComp)
        dataTask.resume()
    }
    
}
