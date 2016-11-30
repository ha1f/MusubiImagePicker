# MusubiImagePicker
## 概要

- フォトライブラリから写真を選択する
- 複数選択可能（上限の設定も可能）
- 少しながらアニメーション
- プレビュー機能（長押しでプレビュー）

![select](https://raw.githubusercontent.com/ha1fha1f/MusubiImagePicker/master/screenshots/select.png)

![anim](https://raw.githubusercontent.com/ha1fha1f/MusubiImagePicker/master/screenshots/anim.gif)

## GettingStarted

#### Carthage

```Cartfile
github "ha1fha1f/MusubiImagePicker"
```

をCartfileに追記してビルド
その他、Copyなどの設定は通常のCarthageと同様

#### Info.plist

```
NSPhotoLibraryUsageDescription
```

というキーに、画像を使う理由を書く（iOS 10.0以降では必須）

#### ViewController(example)

1. MusubiImagePicker.instanciate()でインスタンス生成（イニシャライザを使わない）
1. delegateを設定（MusubiImagePickerDelegateを実装、）
1. delegateメソッドを実装する

```swift
import UIKit
import MusubiImagePicker
import Photos

class ViewController: UIViewController, MusubiImagePickerDelegate {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // .instanciate()によりインスタンス化します（イニシャライザは使わない）
        let picker = MusubiImagePicker.instanciate()

        // .musubiImagePickerDelegateを設定します（.delegateはnavigationControllerに向いています）
        picker.musubiImagePickerDelegate = self

        // すでにAssetを選択している場合は、ここでlocalIdentifierを渡すことができます（任意）
        picker.previouslySelectedAssetLocalIdentifiers = ["ED7AC36B-A150-4C38-BB8C-B6D696F4F2ED/L0/001", "495F9CF5-F638-4694-9C48-B73451DA9C7A/L0/001"]

        // 選択可能枚数の上限を設定したい場合は、ここで設定できます（任意）
        picker.maxSelectionsCount = 4

        // 基本的にはモーダルとして表示します
        self.present(picker, animated: true, completion: nil)
    }

    // Doneが押されたときに呼ばれます（基本的にはここで閉じます）
    func didFinishPickingAssets(picker: MusubiImagePicker, selectedAssets: [PHAsset], assetCollection: PHAssetCollection!) {
        picker.dismiss(animated: true, completion: nil)
        print(selectedAssets.map({ $0.localIdentifier }))
    }

    // Cancelが押されたときに呼ばれます（基本的にはここで閉じます）
    func didCancelPickingAssets(picker: MusubiImagePicker) {
        picker.dismiss(animated: true, completion: nil)
        print("canceled")
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


## ライセンス
ExampleappusingPhotosframework以下のファイルは、Appleの公式サンプル[ExampleappusingPhotosframework](https://developer.apple.com/library/content/samplecode/UsingPhotosFramework/Introduction/Intro.html)から取得したものを一部コメントアウトして使っています

CheckBoxViewは、[mashiroyuya/CheckBoxCollectionView](https://github.com/mashiroyuya/CheckBoxCollectionView)を少し改変して使っています。

問題があればご連絡ください。
