//
//  ViewController.swift
//  MyFavouritePokemonMain
//
//  Created by Simarjeet Kaur on 16/05/25.
//

//
//  ViewController.swift
//  MyFavouritePokemon
//
//  Created by Simarjeet Kaur on 16/05/25.
//
//
//import UIKit
//
//class HomeViewController: UIViewController {
//    
//    private let welcomeLabel : UILabel = {
//        let label=UILabel()
//        label.text="Welcome to Pokémon Picker"
//        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    private let browseButton : UIButton={
//        let button=UIButton(type: .system)
//        button.setTitle("Browse Pokémon", for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        button.backgroundColor = UIColor.systemPink
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius=10
//        return button
//    }()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        view.backgroundColor = .white
//        title="Home"
//        setupViews()
//        browseButton.addTarget(self, action: #selector(goToPokemonList), for: .touchUpInside)
//    }
//    func setupViews(){
//        view.addSubview(welcomeLabel)
//        view.addSubview(browseButton)
//        welcomeLabel.translatesAutoresizingMaskIntoConstraints=false
//        browseButton.translatesAutoresizingMaskIntoConstraints=false
//        welcomeLabel.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive=true
//        welcomeLabel.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 24).isActive=true
//        welcomeLabel.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -24).isActive=true
//        
//        browseButton.topAnchor.constraint(equalTo:welcomeLabel.bottomAnchor, constant: 40).isActive=true
//        browseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
//        browseButton.widthAnchor.constraint(equalToConstant: 200).isActive=true
//        browseButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
//    }
//    @objc private func goToPokemonList(){
//        let listVC=PokemonListViewController()
//        navigationController?.pushViewController(listVC, animated: true)
//    }
//}
//
//
//
import UIKit

class HomeViewController: UIViewController, PokemonSelectionDelegate {
    let backgroundImage = UIImageView()
    let pokemonImageView = UIImageView()
    let nameLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
            setupBackground()
            setupUI()
            loadSavedPokemon()
    }

    func setupBackground() {
        backgroundImage.image = UIImage(named: "pikachu")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setupUI() {
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        pokemonImageView.image = UIImage(named: "questionMark")
        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageView.layer.cornerRadius = 10
        pokemonImageView.clipsToBounds = true
        pokemonImageView.layer.borderWidth = 2
        pokemonImageView.layer.borderColor = UIColor.white.cgColor

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Your Pokémon Awaits!"
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = .white
        nameLabel.shadowColor = .black
        nameLabel.shadowOffset = CGSize(width: 1, height: 1)

        let button = UIButton(type: .system)
        button.setTitle("Choose Your Pokémon", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.9)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pickPokemon), for: .touchUpInside)

        view.addSubview(pokemonImageView)
        view.addSubview(nameLabel)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            pokemonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 150),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 150),

            nameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            button.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc func pickPokemon() {
        let listVC = PokemonListViewController()
        listVC.delegate = self
        present(listVC, animated: true)
    }

    func didSelectPokemon(pokemon: Pokemon) {
        // Update UI
        nameLabel.text = pokemon.name
        if let url = URL(string: pokemon.imageURL) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.pokemonImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        // Save to UserDefaults
        if let encoded = try? JSONEncoder().encode(pokemon) {
            UserDefaults.standard.set(encoded, forKey: "selectedPokemon")
        }
    }
    func loadSavedPokemon() {
        if let savedData = UserDefaults.standard.data(forKey: "selectedPokemon"),
           let savedPokemon = try? JSONDecoder().decode(Pokemon.self, from: savedData) {
            nameLabel.text = savedPokemon.name
            if let url = URL(string: savedPokemon.imageURL) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.pokemonImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
    }
}
