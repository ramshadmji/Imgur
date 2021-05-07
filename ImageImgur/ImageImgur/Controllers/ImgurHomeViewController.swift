//
//  ImgurHomeViewController.swift
//  Imgur
//
//  Created by Mohammed Ramshad K on 06/05/21.
//

import UIKit

class ImgurHomeViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var imageSectionTitle: UIView!
    @IBOutlet weak var sectionTitle: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var switchButton: UIButton!
    
    var imgurModel = [ImgurModel]()
    var mypicker = UIPickerView()
    var toolBar = UIToolbar()
    
    let poickerArray = ["hot","top","user"]
    var selectedRow:Int = 1
    var isListView = false
    private lazy var listCVLayout: UICollectionViewFlowLayout = {

        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        collectionFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
        collectionFlowLayout.minimumInteritemSpacing = 0
        collectionFlowLayout.minimumLineSpacing = 0
        collectionFlowLayout.scrollDirection = .vertical
        return collectionFlowLayout
    }()

    private lazy var gridCVLayout: UICollectionViewFlowLayout = {
        
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        collectionFlowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 80) / 2 , height: UIScreen.main.bounds.height*0.16)
        collectionFlowLayout.minimumInteritemSpacing = 20
        collectionFlowLayout.minimumLineSpacing = 20
        return collectionFlowLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "ImgurCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImgurCollectionViewCell")
        callingImgurApi(section: "hot")
    }
    func setupPicker(){
        self.mypicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        mypicker.delegate = self
        mypicker.dataSource = self
        self.mypicker.backgroundColor = UIColor.white
        sectionTitle.inputView = self.mypicker
        
        // ToolBar
        toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePicked))
        doneButton.tintColor = UIColor.black
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancellButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelPicked))
        cancellButton.tintColor = UIColor.black
        toolBar.setItems([cancellButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        sectionTitle.inputAccessoryView = toolBar
    }
    
    @objc func donePicked(){
        sectionTitle.text = poickerArray[selectedRow]
        callingImgurApi(section: sectionTitle.text!)
    }
    @objc func cancelPicked(){
        self.view.endEditing(true)
    }
    
    @IBAction func switchButtonClicked(_ sender: Any) {
        
        if switchButton.title(for: .normal) == "Grid"{
            isListView = false
            switchButton.setTitle("List", for: .normal)
        }
        self.collectionView.startInteractiveTransition(to: isListView ? self.listCVLayout : self.gridCVLayout, completion: nil)
         self.collectionView.finishInteractiveTransition()
    }
    
    func callingImgurApi(section: String) {
        showSpinner(onView: self.view)
        ApiManager.callingImgurApi(section: section) { [self] (response) in
            self.removeSpinner()
            imgurModel = response
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        } failure: { (error) in
            self.removeSpinner()
            self.showToast(controller: self, message: "Failed To Load......", seconds: 5)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imgurModel.count > 0 {
            return imgurModel.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgurCollectionViewCell", for: indexPath) as? ImgurCollectionViewCell{
            cell.configureCell(with: imgurModel[indexPath.row])
        return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: 150.0)
    }
}

extension ImgurHomeViewController: UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return poickerArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return poickerArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        mypicker.reloadAllComponents()
    }
}
