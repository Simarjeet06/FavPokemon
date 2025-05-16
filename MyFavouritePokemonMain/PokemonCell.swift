//
//  PokemonCell.swift
//  MyFavouritePokemonMain
//
//  Created by Simarjeet Kaur on 16/05/25.
//
import Foundation
import UIKit
class PokemonCell: UITableViewCell {
    let pokeImage = UIImageView()
    let nameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        pokeImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(pokeImage)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            pokeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            pokeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokeImage.widthAnchor.constraint(equalToConstant: 50),
            pokeImage.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.leadingAnchor.constraint(equalTo: pokeImage.trailingAnchor, constant: 15),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name
        if let url = URL(string: pokemon.imageURL) {
            // Simple image fetch
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.pokeImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
