//
//  ViewController.swift
//  Iconoblast
//
//  Created by Space 1337 on 2/27/24.
//

import UIKit


struct Directory {
    var folderName: String
    var folderUrl: URL
    var image: UIImage
    
}

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    
    var cyanA200 = UIColor(red: 24/255, green: 255/255, blue: 255/255, alpha: 1)
    var purpleA200 = UIColor(red: 224/255, green: 64/255, blue: 251, alpha: 1)
    var deepPurple200 = UIColor(red: 209/255, green: 196/255, blue: 233/255, alpha: 1)
    var deepPurpleA200 = UIColor(red: 124/255, green: 77/255, blue: 255/255, alpha: 1)
    var deepPurple500 = UIColor(red: 103/255, green: 58/255, blue: 183/255, alpha: 1)
    var pinkA400 = UIColor(red: 245/255, green: 0, blue: 87/255, alpha: 1)
    var lightGreenA200 = UIColor(red: 178/255, green: 255/255, blue: 89/255, alpha: 1)
    
    var selectedImageButton = UIButton(type: .system)
    var appNameTextField = UITextField()
    var headerLabel = UILabel()
    
    let imagePicker = UIImagePickerController()
    var appName : String = ""
    
    var listOfFolder = [String]()
    var logoImage: UIImageView!
    var tableView0: UITableView!
    var arrayDir: [Directory] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        imagePicker.delegate = self
        setupHeader()
        setupLogoImage()
        setupTextField()
        setupImageSelectButton()
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let numberOfFolders = countFolders(in: documentsURL)
        print("*** Number of folders in directory: \(numberOfFolders)")
        
        let documentsURL1 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
       
        let list = listFoldersAndImages(in: documentsURL1)
        print("\(list)")
        
//        let tapper = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap(gesture:)))
//        tapper.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapper)
        
        configureTableView()
        print("*** Folder Names: \(list)")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
 
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            // Check the orientation after the transition animation completes
            self.checkOrientation()
        }, completion: nil)
    }
    
    func checkOrientation() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let interfaceOrientation = windowScene.windows.first?.windowScene?.interfaceOrientation else {
            print("Unable to determine interface orientation")
            return
        }
        if interfaceOrientation.isLandscape {
            print("The view is in landscape mode")
        } else {
            print("The view is in portrait mode")

        }
    }
    
    @objc func tap(gesture: UITapGestureRecognizer) {
        appNameTextField.resignFirstResponder()
    }
    
    func selectImageTapped() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setupHeader(){
        headerLabel.frame = CGRect(x: 50, y: 50, width: 240, height: 50)
         headerLabel.text = "Iconoblast"
        headerLabel.textColor = .white
        headerLabel.layer.shadowColor = UIColor.darkGray.cgColor
         headerLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
         headerLabel.layer.shadowRadius = 1
         headerLabel.layer.shadowOpacity = 0.8
         headerLabel.font = .boldSystemFont(ofSize: 50)
         view.addSubview(headerLabel)
    }
    
    
    
    func setupLogoImage() {
        
        let frame = CGRect(x: headerLabel.frame.maxX + 10, y: 50, width: 50, height: 50)
        logoImage = UIImageView(frame: frame)

        // Set the background color of the UIImageView
        // logoImage.backgroundColor = .lightGray

        // Set the content mode of the UIImageView
        logoImage.contentMode = .scaleAspectFill
        logoImage.layer.shadowOpacity = 0.3
        logoImage.layer.shadowOffset = CGSize(width: 2, height: 2)
        logoImage.layer.shadowRadius = 4
        logoImage.layer.cornerRadius = 10
        logoImage.clipsToBounds = true

        // Set the image for the UIImageView
        logoImage.image = UIImage(named: "AppIcon")

        // Add the UIImageView as a subview
        view.addSubview(logoImage)
        
    }
    
    func setupImageSelectButton() {
        
        selectedImageButton.frame = CGRect(x: (view.frame.width / 2) - 150, y: appNameTextField.frame.maxY + 10, width: 300, height: 40)
        
        
        selectedImageButton.setTitle("  Select App Icon Image", for: .normal)
        selectedImageButton.titleLabel?.textAlignment = .center
        selectedImageButton.contentHorizontalAlignment = .center
        selectedImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        selectedImageButton.layer.shadowOpacity  = 0.8
        selectedImageButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        selectedImageButton.layer.shadowRadius = 1
        selectedImageButton.layer.cornerRadius = 8
        
        selectedImageButton.backgroundColor  = .darkGray
        selectedImageButton.layer.shadowColor = UIColor.black.cgColor
    
        
        selectedImageButton.setImage(UIImage(systemName: "photo"), for: .normal)
        selectedImageButton.tintColor = lightGreenA200
        selectedImageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
     
        view.addSubview(selectedImageButton)
    }
    
    func setupTextField() {
        appNameTextField.frame = CGRect(x: (view.frame.width / 2) - 150, y: headerLabel.frame.maxY + 10, width: 300, height: 50)
        appNameTextField.placeholder = "Enter App Name"
        appNameTextField.font = .boldSystemFont(ofSize: 18)
        appNameTextField.borderStyle = .roundedRect
        appNameTextField.backgroundColor  = .darkGray
        appNameTextField.layer.shadowColor = UIColor.black.cgColor
        appNameTextField.layer.shadowOffset = CGSize(width: 3, height: 3)
        appNameTextField.layer.shadowRadius = 1
        appNameTextField.layer.shadowOpacity = 0.7
        appNameTextField.delegate = self
        view.addSubview(appNameTextField)
        
    }
    
    @objc func selectImage() {
        if appNameTextField.text == "" {
            print("Make Textfield first responder ")
            appNameTextField.becomeFirstResponder()
            //showAlert(with: "Error", message: "Enter app name to continue")
        } else {
            appName = appNameTextField.text!
            selectImageTapped()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        // Add any additional actions you want to perform when return key is pressed
  
        selectImage()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     //   appNameTextField.becomeFirstResponder()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        appNameTextField.becomeFirstResponder()
     
        
    }

    @objc func keyboardWillHide(sender: NSNotification) {
       appNameTextField.resignFirstResponder()
    
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            resizeAndSaveIconImages(image: image, iconName: appName)
        }
        picker.dismiss(animated: true, completion: nil)
        reloadTable()
        appNameTextField.text = ""
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func createFolder(named folderName: String) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsURL.appendingPathComponent(folderName)
        
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            print("Folder created at: \(folderURL.path)")
        } catch {
            print("Error creating folder: \(error)")
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let newSize = CGSize(width: newWidth, height: newWidth)
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: newSize))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        imageView.layer.render(in: context)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
    
    
    func showAlert(with title: String?, message: String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Error", style: .default, handler: nil)
        alertController.addAction(okAction)
         present(alertController, animated: true, completion: nil)
    }
    
    
    func countFolders(in directory: URL) -> Int {
        let fileManager = FileManager.default
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: directory.path)
            var folderCount = 0
            for item in contents {
                var isDirectory: ObjCBool = false
                let itemPath = directory.appendingPathComponent(item).path
                if fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory), isDirectory.boolValue {
                    folderCount += 1
                }
            }
            return folderCount
        } catch {
            print("Error: \(error.localizedDescription)")
            return -1
        }
    }
    
    func listFolders(in directory: URL) -> [String] {
        let fileManager = FileManager.default
        var folders: [String] = []
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: directory.path)
            for item in contents {
                if item != ".Trash" {
                    var isDirectory: ObjCBool = false
                    let itemPath = directory.appendingPathComponent(item).path
                    if fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory), isDirectory.boolValue {
                        folders.append(item)
                    }
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return folders
    }
    
    func listFoldersAndImages(in directory: URL) -> ([String], [URL]) {
        let fileManager = FileManager.default
        var folders: [String] = []
        var imageUrls: [URL] = []
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: directory.path)
            
            for item in contents {
                if item != ".Trash" {
                    var isDirectory: ObjCBool = false
                    let itemPath = directory.appendingPathComponent(item).path
                    
                    if fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory), isDirectory.boolValue {
                        folders.append(item)
                   
                        
                        let folderUrl = directory.appendingPathComponent(item)
                        let folderContents = try fileManager.contentsOfDirectory(atPath: folderUrl.path)
                        
                        for file in folderContents {
                            if  file.contains(".jpg") || file.contains(".png") {
                                let imageUrl = folderUrl.appendingPathComponent(file)
                                imageUrls.append(imageUrl)
                            }
                        }
                        
                        var lastImage = URL(string: "")
                        
                        for x in 0..<imageUrls.count {
                            if imageUrls[x].description.contains("120.0") {
                                lastImage = imageUrls[x]
                            } else {
                                print("Do Nothing.")
                            }
                            
                        }
                        
                    
                        
                        do {
                            // Create a UIImage from the local image file
                            let imageData = try Data(contentsOf: lastImage!)
                            let image = UIImage(data: imageData)
                            
                            let newUrl = removeLastSlash(from: folderUrl)
                  
                            let dir = Directory(folderName: item, folderUrl: newUrl!, image: image!)
                         //   imageUrls = []
                            arrayDir.append(dir)
                        } catch {
                            print("Error loading local image: \(error.localizedDescription)")
                        }
                   
                        
                        
                       
                    }
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return (folders, imageUrls)
    }
    
    func removeLastSlash(from url: URL) -> URL? {
        // Convert the URL to a string for modification
        guard var urlString = url.absoluteString.removingPercentEncoding else {
            return nil
        }
        
        // Check if the URL string ends with a '/'
        if urlString.hasSuffix("/") {
            // Remove the last '/' character
            urlString.removeLast()
            
            // Recreate the URL from the modified string
            if let updatedURL = URL(string: urlString) {
                return updatedURL
            }
        }
        
        // Return the original URL if no modification is made
        return url
    }

    
    func reloadTable() {
        arrayDir = []
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let list = listFoldersAndImages(in: documentsURL)
        print(list)
        tableView0.reloadData()
    }



    
    func resizeAndSaveIconImages(image: UIImage, iconName: String) {
        let iconSizes: [CGFloat] = [40,58, 60,64,68, 76,80,87,114,120,128,136,152,167,180,192,1024]
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsURL.appendingPathComponent("\(appName)")
        
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating directory: \(error)")
        }
        
        for x in 0..<iconSizes.count {
            
            let resizedImage = resizeImage(image: image, newWidth: iconSizes[x])
            if let newImage = resizedImage, let data = resizedImage!.jpegData(compressionQuality: 1) {
                
                let filePath = folderURL.appendingPathComponent("\(appName)_\(resizedImage!.size.width).jpg")
                do {
                    try data.write(to: filePath)
                    print("Icon image saved at: \(filePath)")
                 
                    
                } catch {
                    print("Error saving icon image: \(error)")
                }
            }
            
        
        }
    }
    
    
    func configureTableView() {
       print("#7777 Configure TableView")
        tableView0 = UITableView(frame: CGRect(x: 0, y: selectedImageButton.frame.maxY + 10, width: view.frame.width, height: view.frame.height - selectedImageButton.frame.maxY - 10))
        tableView0.register(IconCell.self, forCellReuseIdentifier: "IconCells")
        tableView0.dataSource = self
        tableView0.delegate = self
        tableView0.backgroundColor = UIColor.clear
        view.addSubview(tableView0)
        
    }
    
    func shareFolder(at directoryURL: URL, from sender: UIView) {
        let documentInteractionController = UIDocumentInteractionController(url: directoryURL)
        
        documentInteractionController.presentOptionsMenu(from: sender.bounds, in: sender, animated: true)
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return arrayDir.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tableView0.dequeueReusableCell(withIdentifier: "IconCells") as! IconCell
        cell.isSelected = false
        cell.configureCell(fileName: arrayDir[indexPath.row], viewSize: view.frame.width)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
               heightForRowAt indexPath: IndexPath) -> CGFloat {
       // Make the first row larger to accommodate a custom cell.
      if indexPath.row == 0 {
          return 110
       }


       // Use the default size for all other rows.
       return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if tableView == tableView0 {
          
            print(arrayDir[indexPath.row].folderUrl)
            let location = arrayDir[indexPath.row].folderName
            
            
            guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }

            let folderURL = documentsDirectoryURL.appendingPathComponent("\(location)")
            
//            shareFolder(at: folderURL, from: view)
        }
           
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var returnString = ""
        if  tableView == tableView0 {
            returnString = "App Icons : \(arrayDir.count)"
        }
            return returnString
            
    }
    
    
}
