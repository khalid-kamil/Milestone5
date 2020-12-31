//
//  ViewController.swift
//  Milestone5
//
//  Created by Khalid Kamil on 12/31/20.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // toggle image picker
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
        
        // set up userdefaults
        let defaults = UserDefaults.standard
        
        if let savedPhotos = defaults.object(forKey: "photos") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                photos = try jsonDecoder.decode([Photo].self, from: savedPhotos)
            } catch {
                print("Failed to load photos")
            }
        }
    }
    
    // show the photos in the tableview
    
    // tapping caption shows the image in a new view controller
    
    // create a custom type that stores a filename and a caption
    
    // show the list of saved pictures in a tableview
    
    
    @objc func addNewPhoto() -> Void {
        print("Adding photo...")
        // let user take photos
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
        // add captions to the photos
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let photo = photos[indexPath.row]
        let path = getDocumentsDirectory().appendingPathComponent(photo.image)
        
        cell.textLabel?.text = photo.caption
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // save photo
        self.save()
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its properties
            let path = getDocumentsDirectory().appendingPathComponent(photos[indexPath.row].image)
            vc.selectedPhoto = UIImage(contentsOfFile: path.path)
            vc.selectedPhotoCaption = photos[indexPath.row].caption
            
            
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            photos.remove(at: indexPath.row)
//            self.save()
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.photos.remove(at: indexPath.row)
            self.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let rename = UITableViewRowAction(style: .normal, title: "Rename") { (action, indexPath) in
            let ac = UIAlertController(title: "Rename photo", message: nil, preferredStyle: .alert)
            ac.addTextField { (textfield: UITextField) in
                textfield.placeholder = self.photos[indexPath.row].caption
            }
            ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
                self.photos[indexPath.row].caption = ac.textFields![0].text ?? "Unknown"
                self.save()
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
//        rename.backgroundColor = UIColor.systemOrange
        return [delete, rename]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        var photoCaption = "Unknown"
        
        let ac = UIAlertController(title: "Add Caption", message: "Would you like to add a caption to your photo?", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac] _ in
            let newCaption = ac?.textFields?[0].text
            if newCaption != "" {
                photoCaption = newCaption ?? "Unknown"
            } else {
                photoCaption = "Unknown"
            }
            let photo = Photo(caption: photoCaption, image: imageName)
            self.photos.append(photo)
            self.save()
            self.tableView.reloadData()
        })
        
        // Bring user to the detail view controller of the newly created photo to add a caption
        dismiss(animated: true)
        present(ac, animated: true, completion: nil)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photos")
        } else {
            print("Failed to save people.")
        }
    }
    
}

