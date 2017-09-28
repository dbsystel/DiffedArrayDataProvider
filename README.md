# DiffedArrayDataProvider
A composable wrapper arround `ArrayDataProviding`defined in [Sourcing](https://github.com/lightsprint09/Sourcing) which calculates a diff when its contents change.
The diff is then used to drive animations inside a Table/CollectioView

### Example

Elements of your DataProvider need to implement `Hashable`
```swift
let arrayDataProvider = ArrayDataProvider(rows: [1, 2, 3]
let diffedArrayDataProvider = DiffedArrayDataProvider(dataProvider: arrayDataProvider)

// Use diffedArrayDataProvider 
```

