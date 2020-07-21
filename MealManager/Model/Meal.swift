import Foundation
import RealmSwift

class Meal : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var timing: String = ""
    @objc dynamic var recipe: String = ""
    @objc dynamic var cuisine: String = ""
    @objc dynamic var serving: Int = 0
    @objc dynamic var mainIngredient: String = ""
    @objc dynamic var imageFilePath: String = ""
}
