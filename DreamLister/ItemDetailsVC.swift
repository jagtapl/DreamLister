//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by LALIT JAGTAP on 7/26/17.
//  Copyright © 2017 LALIT JAGTAP. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var thumbImage: UIImageView!
    
    
    var stores = [Store]()
    var typesOfItem = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        // create a test data of stores
//        generateStoreTestData()
        
        // fetch stores
        getStores()

        // fetch item types
        getItemTypes()
        
        // create a test data of item types
//        generateItemTypeTestData()
        
        
        
        // when item is passed from main view to detail view
        if itemToEdit != nil {
            loadItemData()
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
//        let store = stores[row]
//        return store.name

        if component == 0 {
            let store = stores[row]
            return store.name
        } else {
            let itemType = typesOfItem[row]
            return itemType.type
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return stores.count

        if component == 0 {
            return stores.count
        } else {
            return typesOfItem.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1    // only one column in picker
        return 2        // column 0 for store and
                        // column 1 for itemtype
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update when selected
    }

    func generateStoreTestData()
    {
        let store = Store(context: context)
        store.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Tesla Showroom"
        let store3 = Store(context: context)
        store3.name = "Fry Electronics"
        let store4 = Store(context: context)
        store4.name = "Target"
        let store5 = Store(context: context)
        store5.name = "Amazon"
        let store6 = Store(context: context)
        store6.name = "K Mart"
        
        ad.saveContext()
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            //self.storePicker.reloadAllComponents()
            self.storePicker.reloadComponent(0)     // instead reload store in 1st column
        } catch {
            // handle the error
        }
    }

    func generateItemTypeTestData()
    {
        let itemType = ItemType(context: context)
        itemType.type = "Auto"
        let itemType1 = ItemType(context: context)
        itemType1.type = "Electronic"
        let itemType2 = ItemType(context: context)
        itemType2.type = "Furniture"
        let itemType3 = ItemType(context: context)
        itemType3.type = "Travel"
        let itemType4 = ItemType(context: context)
        itemType4.type = "Misc"
        
        ad.saveContext()
        print("Saved test item type data for the picker")
    }

    func getItemTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            self.typesOfItem = try context.fetch(fetchRequest)
            //self.storePicker.reloadAllComponents()
            self.storePicker.reloadComponent(1)             // reload item type in 2nd column
        } catch {
            // handle the error
        }
    }

    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
        var item: Item
        
        let picture = Image(context: context)
        picture.image = thumbImage.image
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit!
        }

        item.toImage = picture

        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        item.toItemType = typesOfItem[storePicker.selectedRow(inComponent: 1)]
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImage.image = item.toImage?.image as? UIImage
            
            // correctly fetch store name for picker (column 0 as store)
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        
                        // correctly fetch item type for picker (column 1 as item type)
                        if let type = item.toItemType {
                            var index = 0
                            repeat {
                                let itmType = typesOfItem[index]
                                if itmType.type == type.type {
                                    storePicker.selectRow(index, inComponent: 1, animated: false)
                                    break;
                                }
                                index += 1
                            } while (index < typesOfItem.count)
                        }

                        
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
            
//            // correctly fetch item type for picker (column 1 as item type)
//            if let type = item.toItemType {
//                var index = 0
//                repeat {
//                    let itmType = typesOfItem[index]
//                    if itmType.type == type.type {
//                        storePicker.selectRow(index, inComponent: 1, animated: false)
//                        break;
//                    }
//                    index += 1
//                } while (index < typesOfItem.count)
//            }
        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImage.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
