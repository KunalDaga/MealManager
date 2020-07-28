import UIKit

class ViewMealViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var selectedMeal : Meal?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = selectedMeal?.name
    }
}
