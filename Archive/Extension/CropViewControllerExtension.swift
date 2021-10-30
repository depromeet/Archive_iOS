//
//  CropViewControllerExtension.swift
//  Archive
//
//  Created by hanwe on 2021/10/30.
//

import CropViewController

extension CropViewController {
    var overlayView: TOCropOverlayView {
        toCropViewController.cropView.gridOverlayView
    }
}
