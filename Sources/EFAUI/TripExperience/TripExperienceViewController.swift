//
//  TripExperienceViewController.swift
//  
//
//  Created by Lennart Fischer on 15.12.22.
//

import UIKit
import SwiftUI

public class TripExperienceViewController: UIHostingController<ActiveTripScreen> {
    
    public init() {
        super.init(rootView: ActiveTripScreen(origin: "Moers", destination: "Aachen"))
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
    }
    
    private func setupUI() {
        
        self.title = "Details"
        self.view.backgroundColor = .systemBackground
        
    }
    
}
