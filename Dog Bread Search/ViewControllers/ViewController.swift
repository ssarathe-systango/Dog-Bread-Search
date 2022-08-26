//
//  ViewController.swift
//  Dog Bread Search
//
//  Created by macmini01 on 29/07/22.
//

import UIKit

class ViewController: UIViewController {

    //MARK: ARRAYS
    
    // bread list array.
    var breadList = [String]()
    
    // filtered bread array
    var filteredBread = [String]()
    
    // dogs images array.
    var dogs = [String]()
    
    //MARK: OUTLETS
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupCollectionView()
        apiCallToGetImages(searchText: "")
        getAllBreadList()
    }
    
    //MARK: TEXT FIELD EDITING CHANGED ACTION
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        tableView.isHidden = true
        tableView.isHidden = !(textField.text?.count ?? 0 > 1)
        
        filteredBread = breadList.filter { $0.localizedCaseInsensitiveContains(textField.text ?? "")  }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: TEXT FIELD DID BEGIN ACTION.
    @IBAction func textFieldDidBegin(_ sender: Any) {
        tableView.isHidden = !(textField.text?.count ?? 0 > 1)
    }
}

//MARK: SETUP TABLE VIEW
extension ViewController {
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: SETUP COLLECTION VIEW
extension ViewController {
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: DogCell.identifier, bundle: nil), forCellWithReuseIdentifier: DogCell.identifier)
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = flowLayout
        
    }
}

//MARK: API CALLING TO GET IMAGES.
extension ViewController {
    func apiCallToGetImages(searchText: String) {
        //MARK: API CALLING
        DataService.shared.fetchDogs(searchText: searchText) { result in
            switch result {
                case .success(let dogImages):
                    for _ in dogImages.message {
//                        print("\(dog)")
                    }
                
                let count = dogImages.message.count > 10 ? 10 : dogImages.message.count
                
                self.dogs.removeAll()
                
                self.dogs.append(contentsOf: dogImages.message[0..<count])
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
                case .failure(let error):
                print(error.localizedDescription)
                }
        }
    }
}

//MARK: API CALLING TO GET ALL BREADS LIST.
extension ViewController {
    func getAllBreadList() {
        DataService.shared.getBreadList { result in
            switch result {
            case .success(let data):
                data.message?.keys.forEach({ bread in
                    self.breadList.append(bread)
                })
            
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: COLLECTION VIEW FOR DISPLAY IMAGES.
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogCell.identifier, for: indexPath) as! DogCell
        cell.configure(imageURL: dogs[indexPath.row])
        cell.layer.cornerRadius = 25
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        return CGSize(width: (collectionWidth/2) - 5, height: (collectionWidth/2) - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerNext") as! ViewControllerNext
        vc.imageURL = dogs[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

//MARK: TABLE VIEW TO SHOW SUGGESTIONS.
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBread.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.TextLabel.text = filteredBread[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        apiCallToGetImages(searchText: filteredBread[indexPath.row])
        textField.text = filteredBread[indexPath.row]
        textField.text = nil
        tableView.isHidden = true
    }
}
