//
//  LoadImageListCell.swift
//  Mission_Wanted_iOS_LoadImagesDemo
//
//  Created by 원태영 on 2023/03/02.
//

import UIKit

class LoadImageListCell: UIView {
    private let loadedImageView = UIImageView()
    private let loadProgressBar = UIProgressView(progressViewStyle: .bar)
    private let loadImageButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 셋업 메서드 나열
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
    }
}
