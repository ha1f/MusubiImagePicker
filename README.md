# MusubiImagePicker
## 概要

- フォトライブラリから写真を選択する
- 複数選択可能

## GettingStarted

#### Carthage

```Cartfile
github "ha1fha1f/MusubiImagePicker"
```

をCartfileに追記してビルド

#### Info.plist

```
NSPhotoLibraryUsageDescription 
```

というキーに、画像を使う理由を書く

#### ViewController(example)

1. MusubiImagePicker.instanciate()でインスタンス生成（イニシャライザを使わない）
1. delegateを設定
1. Delegateメソッドを実装する

```swift
import UIKit
import MusubiImagePicker
import Photos

class ViewController: UIViewController, MusubiImagePickerDelegate {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let picker = MusubiImagePicker.instanciate()
        picker.musubiImagePickerDelegate = self
        self.present(picker, animated: true, completion: nil)
    }
    func didFinishPickingAssets(picker: MusubiImagePicker, selectedAssets: [PHAsset], assetCollection: PHAssetCollection!) {
        print("done")
        picker.dismiss(animated: true, completion: nil)
        print(selectedAssets.count)
    }
}

```

## Build Requirements

Xcode 8.0 (iOS 10.0 SDK) or later

## Runtime Requirements

iOS 10.0, or later

## TODO

- headerCells、を作って、カメラ等を追加できるようにする
- 現状ほぼ改変できないので改変可能にしたい
- iOS 9.xへの対応
- 選択可能な画像の枚数を制限する


## ライセンス
ExampleappusingPhotosframework以下のファイルは、Appleの公式サンプル[ExampleappusingPhotosframework](https://developer.apple.com/library/content/samplecode/UsingPhotosFramework/Introduction/Intro.html)から取得したものを一部コメントアウトして使っています

CheckBoxViewは、[mashiroyuya/CheckBoxCollectionView](https://github.com/mashiroyuya/CheckBoxCollectionView)を少し改変して使っています。

問題があればご連絡ください。
