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
    private var task: URLSessionDataTask = URLSession.shared.dataTask(with: ImageURL[0]) { data, reponse, error in }
    private var workItem: DispatchWorkItem = .init(block: {})
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 셋업 메서드 나열
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        observation?.invalidate()
        observation = nil
    }
    
    private func reset() {
        DispatchQueue.main.async {
            self.setupImageView()
            self.setupProgressBar()
            self.setupButton()
            self.setupStack()
        }
    }
    
    private func setupImageView() {
        let defaultImage = UIImage(systemName: "photo")
        loadedImageView.image = defaultImage
    }
    
    private func setupProgressBar() {
        loadProgressBar.progressTintColor = .tintColor
        loadProgressBar.progress = 0
    }
    
    private func setupButton() {
        loadButton.setTitle("Load", for: .normal)
        loadButton.setTitle("Loading...", for: .selected)
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.layer.cornerRadius = 10
        loadButton.backgroundColor = tintColor
        
        loadButton.addTarget(self, action: #selector(loadImage), for: .touchUpInside)

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
        
        loadedImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        
        loadButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func loadImage(_ sender: UIButton) {
        
        workItem = DispatchWorkItem {
            
            DispatchQueue.main.async {
                sender.isSelected = !sender.isSelected
                guard (0...4).contains(sender.tag) else { return }
                
            }
            
            let url = ImageURL[sender.tag]
            let request = URLRequest(url: url)
            
            self.task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let data, error == nil else {
                    fatalError(error!.localizedDescription)
                }
                
                guard self?.workItem.isCancelled == false else {
                    self?.reset()
                    return
                }
                
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.loadedImageView.image = image
                        sender.isSelected = !sender.isSelected
                    }
                }
            }
            
            self.observation = self.task.progress.observe(\.fractionCompleted,
                                                 options: [.new]) { progress, change in
                DispatchQueue.main.async {
                    guard self.workItem.isCancelled == false else {
                        self.observation?.invalidate()
                        self.observation = nil
                        self.loadProgressBar.progress = 0
                        return
                    }
                    self.loadProgressBar.progress = Float(progress.fractionCompleted)
                }
            }
            
            self.task.resume()
        }
        DispatchQueue.global().async(execute: workItem)
    }
}
