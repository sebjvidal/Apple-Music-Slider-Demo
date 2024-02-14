//
//  AMSlider.swift
//  AMSlider-Demo
//
//  Created by Seb Vidal on 14/02/2024.
//

import UIKit

class AMSlider: UIControl, UIGestureRecognizerDelegate {
    // MARK: - Private Properties
    private var backgroundView: UIView!
    private var progressView: UIView!
    
    private var _progress: Double = 0.5
    private var initialGestureOffset: CGFloat = 0
    
    private var isExpanded: Bool = false {
        didSet { updateUI(for: isExpanded) }
    }
    
    // MARK: - Public Properties
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 330, height: 12)
    }
    
    var progress: Double {
        get {
            return _progress
        } set {
            _progress = newValue
        }
    }
    
    override var tintColor: UIColor! {
        get {
            return progressView.backgroundColor
        } set {
            progressView.backgroundColor = newValue
        }
    }
    
    override var backgroundColor: UIColor? {
        get {
            return backgroundView.backgroundColor
        } set {
            backgroundView.backgroundColor = newValue
        }
    }
    
    var trackingMode: TrackingMode = .offset
    
    var expansionMode: ExpansionMode = .onTouch
    
    // MARK: - init(frame:)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackgroundView()
        setupProgressView()
        setupGestureRecognizers()
    }
    
    // MARK: - init(coder:)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupBackgroundView() {
        backgroundView = UIView()
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 3.5
        backgroundView.layer.cornerCurve = .continuous
        backgroundView.backgroundColor = .tertiarySystemFill
        
        addSubview(backgroundView)
    }
    
    private func setupProgressView() {
        progressView = UIView()
        progressView.alpha = 0.5
        progressView.backgroundColor = tintColor
        
        backgroundView.addSubview(progressView)
    }
    
    private func setupGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.delegate = self
        panGestureRecognizer.addTarget(self, action: #selector(panGestureRecognized))
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer()
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.minimumPressDuration = 0
        longPressGestureRecognizer.addTarget(self, action: #selector(longPressGestureRecognized))
        
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc private func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let location = sender.location(in: self).x
            initialGestureOffset = location - progressView.frame.maxX
        case .possible, .changed:
            setIsExpanded(true, animated: true)
        default:
            setIsExpanded(false, animated: true)
        }
        
        let location = sender.location(in: self).x
        let offset = trackingMode == .offset ? initialGestureOffset : 0
        let width = location - offset
        progressView.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
        
        _progress = min(max(width / frame.width, 0), 1)
        sendActions(for: .valueChanged)
    }
    
    @objc private func longPressGestureRecognized(_ sender: UITapGestureRecognizer) {
        if expansionMode == .onTouch {
            switch sender.state {
            case .began:
                setIsExpanded(true, animated: true)
            case .ended:
                setIsExpanded(false, animated: true)
            default:
                return
            }
        }
    }
    
    private func updateUI(for isExpanded: Bool) {
        progressView.alpha = isExpanded ? 1 : 0.5
        layoutBackgroundView()
    }
    
    private func layoutBackgroundView() {
        let x: CGFloat = 0
        let width = frame.width
        let height: CGFloat = isExpanded ? 12 : 7
        let y = (frame.height / 2) - (height / 2)
        backgroundView.frame = CGRect(x: x, y: y, width: width, height: height)
        backgroundView.layer.cornerRadius = height / 2
    }
    
    private func layoutProgressViewIfNeeded() {
        if progressView.frame.height != frame.height {
            let width = (frame.width * progress) - initialGestureOffset
            let height = backgroundView.frame.height
            progressView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
    }
    
    private func setIsExpanded(_ isExpanded: Bool, animated: Bool) {
        let duration = animated ? 0.15 : 0
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            self.isExpanded = isExpanded
        }
    }
    
    // MARK: - layoutSubviews()
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBackgroundView()
        layoutProgressViewIfNeeded()
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension AMSlider {
    enum TrackingMode {
        case offset
        case absolute
    }
}

extension AMSlider {
    enum ExpansionMode {
        case onTouch
        case onDrag
    }
}
