//
//  PokemonListViewController.swift
//  MyFavouritePokemonMain
//
//  Created by Simarjeet Kaur on 16/05/25.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    var pokemonList:[Pokemon] = []
    var tableview = UITableView()
    weak var delegate: PokemonSelectionDelegate?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Pick your Pokémon "
        view.addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints=false
        tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive=true
        tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive=true
        tableview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        tableview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(PokemonCell.self, forCellReuseIdentifier: "cell")
        fetchPokemonList()
    }

    func fetchPokemonList() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=30")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(PokemonAPIResponse.self, from: data)
                let group = DispatchGroup()
                
                for entry in result.results {
                    group.enter()
                    self.fetchPokemonDetails(for: entry) {
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self.tableview.reloadData()
                }
                
            } catch {
                print("Failed to decode list: \(error)")
            }
        }.resume()
    }

func fetchPokemonDetails(for entry: PokemonListEntry, completion: @escaping () -> Void) {
      let url = URL(string: entry.url)!
      URLSession.shared.dataTask(with: url) { data, _, error in
          guard let data = data else {
              completion()
              return
          }

          do {
              let detail = try JSONDecoder().decode(PokemonDetail.self, from: data)
              let pokemon = Pokemon(name: entry.name.capitalized,
                                    imageURL: detail.sprites.front_default)
              self.pokemonList.append(pokemon)
          } catch {
              print("Failed to fetch detail: \(error)")
          }
          completion()
      }.resume()
  }

}

    extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return pokemonList.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PokemonCell else {
                return UITableViewCell()
            }

            let pokemon = pokemonList[indexPath.row]
            cell.configure(with: pokemon)
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selected = pokemonList[indexPath.row]
            delegate?.didSelectPokemon(pokemon: selected)
            dismiss(animated: true, completion: nil)
        }
    }


