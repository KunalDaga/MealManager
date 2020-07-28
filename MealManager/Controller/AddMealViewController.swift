import UIKit
import RealmSwift

class AddMealViewController: UIViewController, UINavigationControllerDelegate {
    
    //setting up outlets and the variables that they will feed into
    @IBOutlet weak var titleTextField: UITextField!; private var mealName : String = ""
    @IBOutlet weak var timingTextField: UITextField!; private var mealTiming : String = ""
    @IBOutlet weak var recipeTextView: UITextView!; private var mealRecipe : String = ""
    @IBOutlet weak var cuisineTextField: UITextField!; private var mealCuisine : String = ""
    @IBOutlet weak var mainIngredientTextField: UITextField!; private var mealMainIngredient : String = ""
    @IBOutlet weak var servesTextField: UITextField!; private var mealServing : Int = 0
    @IBOutlet weak var imageView: UIImageView!
    
    let realm = try! Realm()
    var fileName : String = ""

    func saveToDirectory(image: UIImage) {
        //Get the Documents Directory URL
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        //need to randomise
        let name = String(Date().timeIntervalSinceReferenceDate)
        fileName = "\(name).jpg"

        let destinationURL = documentsDirectory.appendingPathComponent(fileName)
        
        //Create jpeg Data representation and check if the destination url already exists
        if let data = image.jpegData(compressionQuality:  1.0) {
            //Check if destinationURL already exists
            if !FileManager.default.fileExists(atPath: destinationURL.path) {
                do {
                    try data.write(to: destinationURL)
                    print("Image saved")
                } catch {
                    print("Error saving file:", error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegates as self, more details follow in extensions
        titleTextField.delegate = self 
        timingTextField.delegate = self
        cuisineTextField.delegate = self
        servesTextField.delegate = self
        mainIngredientTextField.delegate = self
        recipeTextView.delegate = self
        
        //need to programmatically give a border to the textView
        recipeTextView.layer.borderColor = UIColor.lightGray.cgColor
        recipeTextView.layer.borderWidth = 1
        recipeTextView.clipsToBounds = true;
        recipeTextView.layer.cornerRadius = 10.0;
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            //Checks if camera can be used
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Camera not available", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func addPressed(_ sender: UIButton) {
        if let text1 = titleTextField.text, let text2 = timingTextField.text, let text3 = cuisineTextField.text, let text4 = servesTextField.text, let text5 = mainIngredientTextField.text, let text6 = recipeTextView.text {
            
            //textField.text gives optional String so using optional binding
            mealName = text1
            mealTiming = text2
            mealCuisine = text3
            mealServing = Int(text4) ?? 1
            mealMainIngredient = text5
            mealRecipe = text6
        }
        
        saveData(mealName, mealTiming, mealCuisine, mealServing, mealMainIngredient, mealRecipe)
        
        let alert = UIAlertController(title: "Recipe added", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        //resetting all the fields to blank
        titleTextField.text = ""
        timingTextField.text = ""
        recipeTextView.text = ""
        timingTextField.text = ""
        cuisineTextField.text = ""
        mainIngredientTextField.text = ""
        servesTextField.text = ""
        imageView.image = nil
    }

    func saveData(_ mealName: String, _ mealTiming: String, _ mealCuisine: String, _ mealServing: Int, _ mealMainIngredient: String, _ mealRecipe: String) {
        do {
            try realm.write {
                let newMeal = Meal()
                newMeal.name = mealName
                newMeal.timing = mealTiming
                newMeal.cuisine = mealCuisine
                newMeal.serving = mealServing
                newMeal.mainIngredient = mealMainIngredient
                newMeal.recipe = mealRecipe
                newMeal.imageFilePath = fileName
                realm.add(newMeal)
            }
        } catch {
            print(error)
        }
    }
}

//MARK: - TextViewDelegate Methods
extension AddMealViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Type something"
        }
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text != "" {
            return true
        } else {
            textView.text = "Type something"
            return false
        }
    }
}

//MARK: - TextFieldDelegate Methods
extension AddMealViewController : UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//MARK: - ImagePicker methods

extension AddMealViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        saveToDirectory(image: image!)

        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
