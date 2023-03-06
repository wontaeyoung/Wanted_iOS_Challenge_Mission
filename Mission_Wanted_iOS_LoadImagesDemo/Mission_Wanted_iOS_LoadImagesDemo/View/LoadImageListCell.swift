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

    private let loadedImageView = UIImageView()
    private let loadProgressBar = UIProgressView(progressViewStyle: .bar)
    private let loadImageButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 셋업 메서드 나열
        setupImageView()
        setupProgressBar()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        let defaultImage = UIImage(systemName: "photo")
        loadedImageView.image = defaultImage
    }
    
    private func setupProgressBar() {
        loadProgressBar.progressTintColor = .blue
        loadProgressBar.progress = 0.5
    }
    
    private func setupButton() {
        loadImageButton.setTitle("Load", for: .normal)
        loadImageButton.setTitleColor(.white, for: .normal)
        loadImageButton.backgroundColor = .blue
        
        loadImageButton.addTarget(self, action: #selector(loadImage), for: .touchUpInside)
    }
    
    @objc private func loadImage(_ sender: UIButton) {
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
                }
            }
        }
        
        task.resume()
    }
}
