//
//  ViewController.swift
//  Mission_Wanted_iOS_LoadImagesDemo
//
//  Created by 원태영 on 2023/03/01.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: -Properties
    private let imageUrls = [
        "https://i.namu.wiki/s/cf31c81bbe8c41c28f894f9d2c2cffa00686a1bddda060ab8bd459aba5997da2c050d5959259f9b5793f76f4ff80dd96bae04f0fd33e286174c59ac8ac7a56e5bf001f194329f4591057479dd8e233d1bd00d29c0c8a7ec8490c990af723d2dc",
        "https://i.namu.wiki/s/110372e9947e16574460900b687e1753cd70d36a3d571b7b889f9b826a9a271a51d3355df015904ed8efe3c4fcf2fb90525e759a5070fea9f19e24eb10f2efab7422646c145eb3a0e680bac5de0d7f8b14e5f1f27fab9599e1ed568511298117",
        "https://i.namu.wiki/s/d0fc0604ee5b4d86861231ca0949bf4a3ddb8c733904fa4e5c2442b5d60cbf92f877a2939105e0f4225baba0c5d8af4a5dbe86ec9a4df486219a8eb9886bb89ad6c15c6fcb8639016b5996e89d5a9ba47890994066f87a42e9a49e00edf53316",
        "https://i.namu.wiki/s/fe247207b3eac8bb23cf9acd9bd19850fcdea9dbe0f2d96dfa137b3f48b960951aeef4cfc90e785cd0ca411bcf68b202de4c543202b02f42ea736993a2961ea461694d7709bea56f8636d445b24c186340bde2243de3a3f6aace3cecd458e82e",
        "https://i.namu.wiki/s/a4333fc6f246e12879bd755404f7bf4be31e27b02266f1a9889bdd93f9a3d9729e80d0aeb200d53ba9477c8b3c0edd4d644c159968897059d7b8ad6659d03a2032559b49ee8e62e45c224c70c30369ef831e4088eb5ce4a519b467e73d457b56"
    ]
    
    private var loadedImages: [UIImageView] = []
    
    // MARK: -Methods
    private func makeSetImageView() -> UIImageView {
        return UIImageView().then {
            $0.image = UIImage(systemName: "photo")
        }
    }
    
    private func makeSetProgressBar() -> UIProgressView {
        return UIProgressView().then {
            $0.progress = 0.5
            $0.progressTintColor = .blue
        }
    }
    
    private func makeSetButton() -> UIButton {
        return UIButton().then {
            $0.setTitle("Load", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .blue
            $0.addTarget(self,
                         action: #selector(loadImage),
                         for: .touchUpInside)
        }
    }
    
    private func makeHStack() -> UIStackView {

         let hStack = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 10
        }
        
        return hStack
    }
    
    @objc private func loadImage(_ sender: UIButton) {
        
        let imageURL = imageUrls[sender.tag]
        
        guard let url = URL(string: imageURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.loadedImages[sender.tag].image = image
                }
            }
        }
        
        task.resume()
    }
    
}

// 프리뷰 생성
import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}

@available(iOS 14.0.0, *)
struct ViewPreview: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}
