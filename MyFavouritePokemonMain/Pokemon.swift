//
//  Pokemon.swift
//  MyFavouritePokemonMain
//
//  Created by Simarjeet Kaur on 16/05/25.
//

struct Pokemon:Codable {
    let name: String
    let imageURL: String
}
struct PokemonAPIResponse: Codable {
    let results: [PokemonListEntry]
}

struct PokemonListEntry: Codable {
    let name: String
    let url: String
}

struct PokemonDetail: Codable {
    let sprites: Sprite
}

struct Sprite: Codable {
    let front_default: String
}

