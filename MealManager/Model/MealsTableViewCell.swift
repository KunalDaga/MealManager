import UIKit
import RealmSwift

class MealsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealLabel: UILabel!
    
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let realm = try! Realm()
    
    func setMeal(_ meal: Meal) {
        mealLabel.text = meal.name
        let image = loadImage(meal)
        mealImage.image = image
    }
    
    func loadImage(_ meal: Meal) -> UIImage? {
        let fileName = meal.imageFilePath
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)!
        } catch {
            print("Error loading image : \(error)")
            return nil
        }
    }
}
