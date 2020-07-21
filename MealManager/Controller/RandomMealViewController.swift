import UIKit
import RealmSwift

class RandomMealViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var recipeLabel: UILabel!
    
    private let realm = try! Realm()
    private var meals: Results<Meal>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meals = realm.objects(Meal.self)
        displayData()
    }
    
    func displayData() {
        if let randomisedMeal = meals?.randomElement() {
            nameLabel.text = randomisedMeal.name
            timingLabel.text = randomisedMeal.timing
            recipeLabel.text = randomisedMeal.recipe
        }
    }
}
