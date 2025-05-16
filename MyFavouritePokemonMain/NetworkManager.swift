//
//  NetworkManager.swift
//  MyFavouritePokemonMain
//
//  Created by Simarjeet Kaur on 16/05/25.
//

//import Foundation
//
//struct PokemonResponse:Decodable{
//    let results :[Pokemon]
//}
//
//
//class NetworkManager{
//    static let shared=NetworkManager()
//    private init(){}
//    
//    func fetchPokemonList(completion:@escaping ([Pokemon]?)->Void){
//        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=100"
//        guard let url=URL(string: urlString) else {
//            completion(nil)
//            return
//        }
//        URLSession.shared.dataTask(with: url){
//            data,_,error in
//            guard let data=data, error == nil else{
//                print("❌ Error fetching data:", error?.localizedDescription ?? "Unknown error")
//                completion(nil)
//                return
//            }
//            do{
//                let decoded=try JSONDecoder().decode(PokemonResponse.self,from:data)
//                completion(decoded.results)
//            }
//            catch{
//                print("❌ Error decoding data:", error.localizedDescription)
//                completion(nil)
//            }
//        }.resume()
//    }
//}
