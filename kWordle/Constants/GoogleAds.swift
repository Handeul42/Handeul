//
//  GoogleAds.swift
//  한들
//
//  Created by 강희영 on 2022/04/25.
//

import GoogleMobileAds
import SwiftUI
import UIKit

struct
GADBannerViewController: UIViewControllerRepresentable {
func makeUIViewController(context: Context) -> UIViewController {
    let view = GADBannerView(adSize: GADAdSizeBanner)
    let viewController = UIViewController()
    view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
    view.rootViewController = viewController
    viewController.view.addSubview(view)
    viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
    view.load(GADRequest())
    return viewController
}
 
func updateUIViewController(
_ uiViewController: UIViewController,
context: Context) {
    
    }
}
