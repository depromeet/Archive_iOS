// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Gen {
  internal enum Colors {
    internal static let black = ColorAsset(name: "Black")
    internal static let dIm = ColorAsset(name: "DIm")
    internal static let errorRed = ColorAsset(name: "ErrorRed")
    internal static let funYellow = ColorAsset(name: "FunYellow")
    internal static let funYellowDarken = ColorAsset(name: "FunYellowDarken")
    internal static let gray01 = ColorAsset(name: "Gray01")
    internal static let gray02 = ColorAsset(name: "Gray02")
    internal static let gray03 = ColorAsset(name: "Gray03")
    internal static let gray04 = ColorAsset(name: "Gray04")
    internal static let gray05 = ColorAsset(name: "Gray05")
    internal static let gray06 = ColorAsset(name: "Gray06")
    internal static let impressiveGreen = ColorAsset(name: "ImpressiveGreen")
    internal static let impressiveGreenDarken = ColorAsset(name: "ImpressiveGreenDarken")
    internal static let myPageGray = ColorAsset(name: "MyPageGray")
    internal static let pleasantRed = ColorAsset(name: "PleasantRed")
    internal static let pleasantRedDarken = ColorAsset(name: "PleasantRedDarken")
    internal static let splendidBlue = ColorAsset(name: "SplendidBlue")
    internal static let splendidBlueDarken = ColorAsset(name: "SplendidBlueDarken")
    internal static let white = ColorAsset(name: "White")
    internal static let wonderfulPurple = ColorAsset(name: "WonderfulPurple")
    internal static let wonderfulPurpleDarken = ColorAsset(name: "WonderfulPurpleDarken")
  }
  internal enum Images {
    internal static let back = ImageAsset(name: "Back")
    internal static let checkBoxAllDeselected = ImageAsset(name: "Check box_all_deselected")
    internal static let checkBoxAllSelected = ImageAsset(name: "Check box_all_selected")
    internal static let checkSquareDeselected = ImageAsset(name: "CheckSquare_deselected")
    internal static let checkSquareSelected = ImageAsset(name: "CheckSquare_selected")
    internal static let coverFun = ImageAsset(name: "cover_fun")
    internal static let coverImpressive = ImageAsset(name: "cover_impressive")
    internal static let coverPleasant = ImageAsset(name: "cover_pleasant")
    internal static let coverSplendid = ImageAsset(name: "cover_splendid")
    internal static let coverWonderful = ImageAsset(name: "cover_wonderful")
    internal static let defaultEmotionMain = ImageAsset(name: "defaultEmotionMain")
    internal static let preFun = ImageAsset(name: "pre_fun")
    internal static let preImpressive = ImageAsset(name: "pre_impressive")
    internal static let prePleasant = ImageAsset(name: "pre_pleasant")
    internal static let preSplendid = ImageAsset(name: "pre_splendid")
    internal static let preWonderful = ImageAsset(name: "pre_wonderful")
    internal static let typeFun = ImageAsset(name: "type=fun")
    internal static let typeFunMini = ImageAsset(name: "type=fun_mini")
    internal static let typeFunNo = ImageAsset(name: "type=fun_no")
    internal static let typeImpressive = ImageAsset(name: "type=impressive")
    internal static let typeImpressiveMini = ImageAsset(name: "type=impressive_mini")
    internal static let typeImpressiveNo = ImageAsset(name: "type=impressive_no")
    internal static let typePleasant = ImageAsset(name: "type=pleasant")
    internal static let typePleasantMini = ImageAsset(name: "type=pleasant_mini")
    internal static let typePleasantNo = ImageAsset(name: "type=pleasant_no")
    internal static let typeSplendid = ImageAsset(name: "type=splendid")
    internal static let typeSplendidMini = ImageAsset(name: "type=splendid_mini")
    internal static let typeSplendidNo = ImageAsset(name: "type=splendid_no")
    internal static let typeWonderful = ImageAsset(name: "type=wonderful")
    internal static let typeWonderfulMini = ImageAsset(name: "type=wonderful_mini")
    internal static let typeWonderfulNo = ImageAsset(name: "type=wonderful_no")
    internal static let logo = ImageAsset(name: "Logo")
    internal static let logoImage = ImageAsset(name: "LogoImage")
    internal static let logoWhite = ImageAsset(name: "Logo_white")
    internal static let addPhoto = ImageAsset(name: "addPhoto")
    internal static let btnApple = ImageAsset(name: "btn_apple")
    internal static let btnCancel = ImageAsset(name: "btn_cancel")
    internal static let expandMoreBlack24dp = ImageAsset(name: "expand_more_black_24dp")
    internal static let iconDropDown = ImageAsset(name: "icon_drop down")
    internal static let iconDropUp = ImageAsset(name: "icon_drop up")
    internal static let iconRightArrow = ImageAsset(name: "icon_right-arrow")
    internal static let kakaotalk = ImageAsset(name: "kakaotalk")
    internal static let triLeft = ImageAsset(name: "triLeft")
    internal static let triRight = ImageAsset(name: "triRight")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
