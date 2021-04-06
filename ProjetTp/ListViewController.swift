//
//  ListViewController.swift
//  ProjetTp
//
//  Created by Zied Houa on 06/04/2021.
//

import UIKit

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    
   
    

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var films : [Movie] = []
    var allData : [Movie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getListMovies()
        // Do any additional setup after loading the view.
    }
  
 
    @IBAction func didChange() {
        if(textField.text?.count == 0) {
            films = allData
            
        }else {
            let filtered = allData.filter { film in
                return (film.title?.uppercased().contains(textField.text!.uppercased()))!
            }
            films = filtered
        }
       
        DispatchQueue.main.async {
            self.tableView.reloadData()
          
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ItemTableViewCell", owner: self, options: nil)?.first as! ItemTableViewCell
        cell.title.text = films[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }

    func getListMovies(){
        let url = URL(string: "https://fakestoreapi.com/products")
        var request = URLRequest(url: url!)
        request.timeoutInterval = 15 // timeout 15 seconds
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if error != nil || data == nil {
                // fail
                print("fail")
            }
            
            let decoder = JSONDecoder()
            do {
                self.films = try decoder.decode([Movie].self, from: data!)
                self.allData = self.films
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                  
                }
            }
            catch {
                print("cant parse")
            }
            }.resume()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Erreur", message: "Voulez-vous vraiment supprimer?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.films.remove(at: indexPath.row)
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
              
            }))
            self.present(alert, animated: true)
            
            
            
        }
    }


}
class Movie: NSObject , Codable {
    var title : String?

}
