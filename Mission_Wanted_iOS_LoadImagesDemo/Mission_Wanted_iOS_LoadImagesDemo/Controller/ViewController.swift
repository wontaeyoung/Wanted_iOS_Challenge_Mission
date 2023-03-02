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
        self.view.backgroundColor = .white
        setStacks(count: 5)
        setLoadAllButton()
        
        
    }
    
    // MARK: -Properties
    private let imageUrls = [
        "https://i.natgeofe.com/n/548467d8-c5f1-4551-9f58-6817a8d2c45e/NationalGeographic_2572187_square.jpg",
        "https://play-lh.googleusercontent.com/XVHP0sBKrRJYZq_dB1RalwSmx5TcYYRRfYMFO18jgNAnxHAIA1osxM55XHYTb3LpkV8",
        "https://pbs.twimg.com/media/Eb-lba0UcAAbJLx.jpg",
        "https://rukminim1.flixcart.com/image/416/416/kph8h3k0/poster/e/w/4/large-adorable-cat-poster-cute-kittens-poster-cat-poster-funny-original-imag3p7tcxuzhpn2.jpeg?q=70",
        "https://i.pinimg.com/originals/aa/02/78/aa02780bbc7e6c5e2d52d9b0e919fbf6.jpg"
    ]
    
    private let tintColor: UIColor = .tintColor
    private var loadedImageViews: [UIImageView] = []
    private var loadButtons: [UIButton] = []
    private var loadedImagesStack = UIStackView()
    private let loadAllButton = UIButton()
    
    // MARK: -Methods
    
    private func setLoadAllButton() {
        
        loadAllButton.setTitle("Load All Images", for: .normal)
        loadAllButton.setTitleColor(.white, for: .normal)
        loadAllButton.layer.cornerRadius = 10
        loadAllButton.backgroundColor = .tintColor
        loadAllButton.addTarget(self,
                     action: #selector(loadAllImages),
                     for: .touchUpInside)
        
        self.view.addSubview(loadAllButton)
        loadAllButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(loadedImagesStack)
            $0.top.equalTo(loadedImagesStack.snp.bottom).offset(20)
        }
    }
    
    private func makeSetImageView() -> UIImageView {
        return UIImageView().then {
            $0.image = UIImage(systemName: "photo")
        }
    }
    
    private func makeSetProgressBar() -> UIProgressView {
        return UIProgressView().then {
            $0.progress = 0.5
            $0.progressTintColor = tintColor
        }
    }
    
    private func makeSetButton(tag: Int) -> UIButton {
        return UIButton().then {
            $0.setTitle("Load", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 10
            $0.backgroundColor = tintColor
            $0.tag = tag
            $0.addTarget(self,
                         action: #selector(loadImage(_:)),
                         for: .touchUpInside)
        }
    }
    
    private func makeHStack(tag: Int) -> UIStackView {

         let hStack = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 5
        }
        stackAddArrangedSubview(stack: hStack, tag: tag)
        return hStack
    }
    
    
    private func stackAddArrangedSubview(stack: UIStackView, tag: Int) {
        let imageView = makeSetImageView()
        let progressBar = makeSetProgressBar()
        let button = makeSetButton(tag: tag)
        
        loadedImageViews.append(imageView)
        loadButtons.append(button)
        
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(progressBar)
        stack.addArrangedSubview(button)
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(80)
        }
        
        button.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(40)
        }
    }
    
    private func setStacks(count: Int) {
        var hStacks: [UIStackView] = []
        for i in 0..<count {
            let hStack = makeHStack(tag: i)
            hStacks.append(hStack)
        }
        let vStack = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 5
            for hStack in hStacks {
                $0.addArrangedSubview(hStack)
                hStack.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                }
            }
        }
        self.view.addSubview(vStack)
        setSNPConstraints(view: vStack)
        loadedImagesStack = vStack
    }
    
    private func setSNPConstraints(view: UIView) {
        view.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(100)
        }
    }
    
    @objc private func loadImage(_ sender: UIButton) {

        DispatchQueue.main.async {
            self.loadedImageViews[sender.tag].image = UIImage(systemName: "photo")
        }
        
        let imageURL = imageUrls[sender.tag]
        
        guard let url = URL(string: imageURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.loadedImageViews[sender.tag].image = image
                }
            }
        }
        task.resume()
    }
    
    @objc private func loadAllImages() {

        for (idx, imageURL) in imageUrls.enumerated() {
            DispatchQueue.main.async {
                self.loadedImageViews[idx].image = UIImage(systemName: "photo")
            }
            
            guard let url = URL(string: imageURL) else { return }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.loadedImageViews[idx].image = image
                    }
                }
            }
            task.resume()
        }
        
        
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
