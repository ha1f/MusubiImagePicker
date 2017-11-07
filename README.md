# MusubiImagePicker

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## 概要

- フォトライブラリから写真を選択する
- 複数選択可能（上限の設定も可能）
- 選択順を保持
- 少しながらアニメーション
- プレビュー機能（長押しでプレビュー）

![select](https://raw.githubusercontent.com/ha1fha1f/MusubiImagePicker/master/screenshots/select.png)

![anim](https://raw.githubusercontent.com/ha1fha1f/MusubiImagePicker/master/screenshots/anim.gif)

## GettingStarted

#### Carthage

```Cartfile
github "ha1f/MusubiImagePicker"
```

をCartfileに追記してビルド
その他、Copyなどの設定は通常のCarthageと同様

#### Info.plist

```
NSPhotoLibraryUsageDescription
```

というキーに、画像を使う理由を書く（iOS 10.0以降では必須）

#### ViewController(example)

```swift
import UIKit
import MusubiImagePicker
import Photos

class ViewController: UIViewController, MusubiImagePickerDelegate {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        var config = MusubiImagePickerConfiguration()
        config.maxSelectionsCount = 3
        config.previouslySelectedAssetLocalIdentifiers = ["ED7AC36B-A150-4C38-BB8C-B6D696F4F2ED/L0/001"]
        MusubiImagePicker.show(from: self, config: config, delegate: self)
    }
}

extension ViewController: MusubiImagePickerDelegate {
    // 選択完了した時
    func musubiImagePicker(didFinishPickingAssetsIn picker: MusubiImagePickerViewController, assets: [String]) {
        print("finish", assets)
    }
    
    // キャンセルされた時
    func musubiImagePicker(didCancelPickingAssetsIn picker: MusubiImagePickerViewController) {
        print("cancel")
    }
}
```

## Build Requirements

Xcode 9.0 (iOS 11.0 SDK)

## Runtime Requirements

iOS 10.0, or later

## TODO

- delegateのinterfaceの修正
- headerCells、を作って、カメラ等を追加できるようにする
- 現状ほぼ改変できないので改変可能にしたい
- iOS 9.xへの対応

## release手順

```sh
./Tool/release.sh
git add .
git commit -m "prepare for release"
git push
```

その後、GitHub上でタグ生成&リリース

## ライセンス
ExampleappusingPhotosframework以下のファイルは、Appleの公式サンプル[ExampleappusingPhotosframework](https://developer.apple.com/library/content/samplecode/UsingPhotosFramework/Introduction/Intro.html)から取得したものを一部コメントアウトして使っています

CheckBoxViewは、[mashiroyuya/CheckBoxCollectionView](https://github.com/mashiroyuya/CheckBoxCollectionView)を少し改変して使っています。

問題があればご連絡ください。
