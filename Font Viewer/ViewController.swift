//
//  ViewController.swift
//  Font Viewer
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var fontFamiliesPopup: NSPopUpButton!
    
    @IBOutlet weak var fontTypesPopup: NSPopUpButton!
    
    @IBOutlet weak var sampleLabel: NSTextField!
    
    
    // MARK: - Properties
    
    var selectedFontFamily: String?
    
    var fontFamilyMembers = [[Any]]()
    
    
    
    // MARK: - Default Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        setupUI()
        populateFontFamilies()
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    // MARK: - Custom Methods
    
    func setupUI() {
        fontFamiliesPopup.removeAllItems()
        fontTypesPopup.removeAllItems()
        sampleLabel.stringValue = ""
        sampleLabel.alignment = .center
    }
    
    
    func populateFontFamilies() {
        fontFamiliesPopup.removeAllItems()
        fontFamiliesPopup.addItems(withTitles: NSFontManager.shared.availableFontFamilies)
        
        handleFontFamilySelection(self)
    }
    
    
    func updateFontTypesPopup() {
        fontTypesPopup.removeAllItems()
        
        for member in fontFamilyMembers {
            if let fontType = member[1] as? String {
                fontTypesPopup.addItem(withTitle: fontType)
            }
        }
        
        fontTypesPopup.selectItem(at: 0)
        handleFontTypeSelection(self)
    }
    
    
    
    // MARK: - IBAction Methods
    
    @IBAction func handleFontFamilySelection(_ sender: Any) {
        if let fontFamily = fontFamiliesPopup.titleOfSelectedItem {
            
            selectedFontFamily = fontFamily
            
            if let members = NSFontManager.shared.availableMembers(ofFontFamily: fontFamily) {
                fontFamilyMembers.removeAll()
                fontFamilyMembers = members
                
                updateFontTypesPopup()
            }
            
            view.window?.title = fontFamily
        }
    }
    
    
    @IBAction func handleFontTypeSelection(_ sender: Any) {
        let selectedMember = fontFamilyMembers[fontTypesPopup.indexOfSelectedItem]
        
        if let postscriptName = selectedMember[0] as? String, let weight = selectedMember[2] as? Int, let traits = selectedMember[3] as? UInt, let fontfamily = selectedFontFamily {
            
            let font = NSFontManager.shared.font(withFamily: fontfamily,
                                                 traits: NSFontTraitMask(rawValue: traits),
                                                 weight: weight,
                                                 size: 19.0)
            sampleLabel.font = font
            sampleLabel.stringValue = postscriptName
        }
    }
    
    
    @IBAction func displayAllFonts(_ sender: Any) {
        let storyboardName = NSStoryboard.Name(stringLiteral: "Main")
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        
        let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "fontsDisplayStoryboardID")
        
        if let fontsDisplayWindowController = storyboard.instantiateController(withIdentifier: storyboardID) as? NSWindowController {
            if let fontsDisplayVC = fontsDisplayWindowController.contentViewController as? FontsDisplayViewController {
                fontsDisplayVC.fontFamily = selectedFontFamily
                fontsDisplayVC.fontFamilyMembers = fontFamilyMembers
            }
            
            
            fontsDisplayWindowController.showWindow(nil)
        }
    }
    
}

