//
//  LoadImageListCell.swift
//  Mission_Wanted_iOS_LoadImagesDemo
//
//  Created by 원태영 on 2023/03/02.
//

import UIKit
import SnapKit
import Then

class LoadImageListCell: UIView {
    private let imageURL: String = "https://mblogthumb-phinf.pstatic.net/MjAxODA4MjlfMjEw/MDAxNTM1NTEwNjY3MTM5.u_xSHWlSfLTDHEsbhK0vosyEkW_yyvvnA5oZGp35ykog.ntHRxFh3p4WsmWXorRqypgMkJVneVrM0qNcIHltsa8Qg.PNG.wantedlab/%EC%9B%90%ED%8B%B0%EB%93%9C_%EB%A1%9C%EA%B3%A0.png?type=w800"
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
    
    @objc private func loadImage() {
        guard let url = URL(string: imageURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.loadedImageView.image = image
                }
            }
        }
        
        task.resume()
    }
}
