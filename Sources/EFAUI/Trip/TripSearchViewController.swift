//
//  TripSearchViewController.swift
//  
//
//  Created by Lennart Fischer on 05.04.22.
//

#if canImport(UIKit)

import UIKit
import SwiftUI
import EFAAPI

public class TripSearchViewController: UIHostingController<TripSearchScreen> {
    
    private let viewModel: TripSearchViewModel
    
    public init(viewModel: TripSearchViewModel) {
        
        self.viewModel = viewModel
        
        super.init(rootView: TripSearchScreen(
            viewModel: viewModel
        ))
        
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#endif
