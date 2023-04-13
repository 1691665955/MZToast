# MZToast
Toast、Loading

#### Cocoapods
```
pod 'MZToast', '~> 0.0.1'
```

#### Toast
```
// easy show toast
MZToast.showToast("I am a loading view")

// show toast with some params
MZToast.showToast("I am a bottom toast", duration: 2.0, position: .Bottom) { auto in
    NSLog("Toast dismiss \(auto ? "auto" : "cover")")
}
```

#### Loading
```
// show loading view with message
MZToast.showLoading("I am a loading view")

// show loading view without mask
MZToast.showLoading(showMask: false)

// hide loading view
MZToast.hideLoading()
```

#### Config
You can config the toast style through MZToastConfig