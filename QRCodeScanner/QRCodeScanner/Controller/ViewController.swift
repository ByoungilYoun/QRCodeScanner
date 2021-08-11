//
//  ViewController.swift
//  QRCodeScanner
//
//  Created by 윤병일 on 2021/08/11.
//

import UIKit
import SnapKit
import AVFoundation

class ViewController: UIViewController {

  //MARK: - Properties
  let readerView = ReaderView()

  lazy var readButton : UIButton = {
    let bt = UIButton()
    bt.setTitle("시작", for: .normal)
    bt.setTitleColor(.black, for: .normal)
    bt.backgroundColor = .yellow
    bt.addTarget(self, action: #selector(readButtonTapped), for: .touchUpInside)
    return bt
  }()


  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if !self.readerView.isRunning {
      self.readerView.stop(isButtonTap: false)
    }
  }

  //MARK: - Functions
  private func configureUI() {
    view.backgroundColor = .white
    readerView.delegate = self

    readButton.layer.masksToBounds = true
    readButton.layer.cornerRadius = 15

    [readerView, readButton].forEach {
      view.addSubview($0)
    }

    readerView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(300)
    }

    readButton.snp.makeConstraints {
      $0.top.equalTo(readerView.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(200)
      $0.height.equalTo(50)
    }
  }

  //MARK: - @objc func
  @objc func readButtonTapped(_ sender : UIButton) {
    if self.readerView.isRunning {
      self.readerView.stop(isButtonTap: true)
    } else {
      self.readerView.start()
    }
    sender.isSelected = self.readerView.isRunning
  }
}

  //MARK: - extension ReaderViewDelegate
extension ViewController : ReaderViewDelegate {
  func readerComplete(status: ReaderStatus) {
    var title = ""
    var message = ""
    switch status {
    case let .success(code):
        guard let code = code else {
            title = "에러"
            message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
            break
        }

        title = "알림"
        message = "인식성공\n\(code)"
    case .fail:
        title = "에러"
        message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
    case let .stop(isButtonTap):
        if isButtonTap {
            title = "알림"
            message = "바코드 읽기를 멈추었습니다."
            self.readButton.isSelected = readerView.isRunning
        } else {
            self.readButton.isSelected = readerView.isRunning
            return
        }
    }

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)

    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
}
