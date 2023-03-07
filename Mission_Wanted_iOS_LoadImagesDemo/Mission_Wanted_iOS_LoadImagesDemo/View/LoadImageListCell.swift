//
//  LoadImageListCell.swift
//  Mission_Wanted_iOS_LoadImagesDemo
//
//  Created by 원태영 on 2023/03/02.
//

import UIKit
import SnapKit
import Then

fileprivate enum ImageURL {
    private static let imageIds: [String] = [
        "europe-4k-1369012",
        "europe-4k-1318341",
        "europe-4k-1379801",
        "cool-lion-167408",
        "iron-man-323408"
    ]
    
    static subscript(index: Int) -> URL {
        let id = imageIds[index]
        return URL(string: "https://wallpaperaccess.com/download/"+id)!
    }
}

class LoadImageListCell: UIView {

    let loadedImageView = UIImageView()
    let loadProgressBar = UIProgressView(progressViewStyle: .bar)
    let loadButton = UIButton()
    private let hStack = UIStackView()
    private var observation: NSKeyValueObservation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 셋업 메서드 나열
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reset() {
        setupImageView()
        setupProgressBar()
        setupButton()
        setupStack()
    }
    
    private func setupImageView() {
        let defaultImage = UIImage(systemName: "photo")
        loadedImageView.image = defaultImage
//        self.addSubview(loadedImageView)
    }
    
    private func setupProgressBar() {
        loadProgressBar.progressTintColor = .blue
        loadProgressBar.progress = 0
//        self.addSubview(loadProgressBar)
    }
    
    private func setupButton() {
        loadButton.setTitle("Load", for: .normal)
        loadButton.setTitle("Loading...", for: .selected)
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.backgroundColor = .blue
        
        loadButton.addTarget(self, action: #selector(loadImage), for: .touchUpInside)
//        self.addSubview(loadButton)
    }
    
    private func setupStack() {
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.alignment = .center
        hStack.spacing = 5
        
        hStack.addArrangedSubview(loadedImageView)
        hStack.addArrangedSubview(loadProgressBar)
        hStack.addArrangedSubview(loadButton)
        self.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func loadImage(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        guard (0...4).contains(sender.tag) else { return }
        
        let url = ImageURL[sender.tag]
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.loadedImageView.image = image
                    sender.isSelected = !sender.isSelected
                }
            }
        }
        
        observation = task.progress.observe(\.fractionCompleted,
                                             options: [.new]) { progress, change in
            DispatchQueue.main.async {
                self.loadProgressBar.progress = Float(progress.fractionCompleted)
            }
        }
        
        task.resume()
    }
}
