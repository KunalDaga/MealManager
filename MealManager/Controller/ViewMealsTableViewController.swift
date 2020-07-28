import UIKit
import RealmSwift

class ViewMealsTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var meals : Results<Meal>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        meals = realm.objects(Meal.self)
        tableView.reloadData()
    }
    
    // MARK: - TableView data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealsTableViewCell
        
        cell.setMeal((meals?[indexPath.row])!)
        
        //cell.nameLabel.text = meals?[indexPath.row].name
        //cell.timingLabel.text = meals?[indexPath.row].timing
        //cell.mealImageView.image = #imageLiteral(resourceName: "final_5cb881af08c960001434160e_815672")
        //cell.mealImageView.image = meals?[indexPath.row].imageFilePath
        
        return cell
    }
    
    //MARK: - TableView Delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToViewMeals", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewMealViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedMeal = meals?[indexPath.row]
        }
    }
}

//MARK: - Search Bar Delegate methods
extension ViewMealsTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        meals = meals?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
