![Build Status](https://travis-ci.com/dbsystel/DiffedArrayDataProvider.svg?branch=master)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
# DiffedArrayDataProvider
A composable wrapper arround `CollectionDataProvider` defined in [Sourcing](https://github.com/lightsprint09/Sourcing) which calculates a diff when its content changes.
The diff is then used to drive animations inside a Table/CollectioView.

## Usage

Elements of your data provider need to implement `Hashable`
```swift
let arrayDataProvider = ArrayDataProvider(rows: [1, 2, 3])
let diffedArrayDataProvider = DiffedArrayDataProvider(dataProvider: arrayDataProvider)

// Use diffedArrayDataProvider 
```

## Requirements
- iOS 9.3+
- Xcode 11.0+
- Swift 5.0

## Installation

### Swift Package Manager

[SPM](https://swift.org/package-manager/) is integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Specify the following in your `Package.swift`:

```swift
.package(url: "https://github.com/dbsystel/DiffedArrayDataProvider", from: "2.0.0"),
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

Specify the following in your `Cartfile`:

```ogdl
github "dbsystel/DiffedArrayDataProvider" ~> 2.0
```
## Contributing
Feel free to submit a pull request with new features, improvements on tests or documentation and bug fixes. Keep in mind that we welcome code that is well tested and documented.

## Contact
Lukas Schmidt ([Mail](mailto:lukas.la.schmidt@deutschebahn.com), [@lightsprint09](https://twitter.com/lightsprint09))

## License
DiffedArrayDataProvider is released under the MIT license. See LICENSE for details.
