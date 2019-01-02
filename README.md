![Build Status](https://travis-ci.com/dbsystel/DiffedArrayDataProvider.svg?branch=master)](https://travis-ci.org/dbsystel/DBNetworkStack-Sourcing)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
# DiffedArrayDataProvider
A composable wrapper arround `ArrayDataProvider`defined in [Sourcing](https://github.com/lightsprint09/Sourcing) which calculates a diff when its content changes.
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
- Xcode 10.1+
- Swift 4.2

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

Specify the following in your `Cartfile`:

```ogdl
github "dbsystel/DiffedArrayDataProvider" ~> 1.0
```
## Contributing
Feel free to submit a pull request with new features, improvements on tests or documentation and bug fixes. Keep in mind that we welcome code that is well tested and documented.

## Contact
Lukas Schmidt ([Mail](mailto:lukas.la.schmidt@deutschebahn.com), [@lightsprint09](https://twitter.com/lightsprint09))

## License
DiffedArrayDataProvider is released under the MIT license. See LICENSE for details.
