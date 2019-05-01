//
//  HorizontalCell.swift
//  WorkSafe
//
//  Created by Andre Frank on 30.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

protocol HorizontalPickerViewDataSource: class {
    func numberOfItemsInPickerView(horizontalPickerView: HorizontalPickerView) -> Int
    func titleforItemInPickerView(horizontalPickerView: HorizontalPickerView, forItem item: Int) -> String
}

protocol HorizontalPickerViewDelegate: class {
    func pickerView_didSelectItem(pickerView: HorizontalPickerView, item: Int)
    func pickerView_willBeginChangeItem(pickerView: HorizontalPickerView)
}


class HorizontalPickerView: UIView, UIScrollViewDelegate {
    weak var delegate: HorizontalPickerViewDelegate?
    
    weak var dataSource: HorizontalPickerViewDataSource?
    
    let  constPickerDecelerationThreshold=CGFloat(2.9)
    
    // Views
    var contentView: UIScrollView!
    var recycledViews = NSMutableSet()
    var visibleViews = NSMutableSet()
    
    var itemCount: Int = 0
    
    // Current status
    
    var selectedItem:Int=0{
        willSet{
            if newValue > itemCount {
                self.selectedItem=itemCount
                return
            }
            
            setSelectedItem(selectedItem:newValue, animated: false)
        }
    }
    
    var itemFont: UIFont!{
        willSet{
            for view in visibleViews{
                if let alabel=view as? UILabel{
                    alabel.font=newValue
                }
            }
            
            for view in recycledViews{
                if let alabel=view as? UILabel{
                    alabel.font=newValue
                }
            }
        }
    }
    
    
    var itemColor:UIColor!{
        willSet{
            for view in visibleViews{
                if let alabel=view as? UILabel{
                    alabel.textColor=newValue
                }
            }
            
            for view in recycledViews{
                if let alabel=view as? UILabel{
                    alabel.textColor=newValue
                }
            }

        }
    }
    
    var showGlass: Bool = true{
        willSet{
            if newValue != showGlass{
                setNeedsDisplay()
            }
        }
    }
        
    var peekInset: UIEdgeInsets=UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0){
        willSet{
                contentView.frame = bounds.inset(by: newValue)
                reloadData()
                contentView.setNeedsDisplay()
        }
    }
    
    var backGroundImage: UIImage?{
        willSet{
            if newValue !== backGroundImage{
                self.setNeedsDisplay()
            }
        }
        
    }
    
    
    var glassImage: UIImage?{
        willSet{
            if newValue !== glassImage{
                self.setNeedsDisplay()
            }
        }
        
    }
    
    var shadowImage: UIImage? {
        willSet{
            if newValue !== glassImage{
                self.setNeedsDisplay()
            }
        }
    }
    
    
    var enabled:Bool{
        get{
            return contentView.isScrollEnabled
        }
        set{
            contentView.isScrollEnabled=enabled
        }
    }
    

    var allowSlowDeceleration: Bool = true
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        commonInit()
    }
    
    func commonInit() {
        itemFont = UIFont.boldSystemFont(ofSize: 24.0)
        itemColor = UIColor.black
        showGlass = false
        allowSlowDeceleration = false
        itemCount = 0
        visibleViews = NSMutableSet()
        recycledViews = NSMutableSet()
    }
    
    func setupView() {
        let frame=bounds.inset(by: peekInset)
        contentView=UIScrollView(frame: frame)
        
        contentView.clipsToBounds = false
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.isPagingEnabled = true
        contentView.scrollsToTop = false
        contentView.delegate=self
        addSubview(contentView)
        
        if UIDevice.current.systemVersion >= "5.0" {
            backGroundImage = UIImage(named: "wheelBackground")?.resizableImage(withCapInsets: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
            
            glassImage = UIImage(named: "stretchableGlass")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1))
            
        } else {
            backGroundImage=UIImage(named: "wheelBackground")?.stretchableImage(withLeftCapWidth: 1, topCapHeight: 0)
            glassImage=UIImage(named: "stretchableGlass")?.stretchableImage(withLeftCapWidth: 1, topCapHeight: 0)
        }
        
        shadowImage=UIImage(named: "shadowOverlay")
        
        layer.cornerRadius = 3
        clipsToBounds = true
        layer.borderColor = UIColor(white: 0.15, alpha: 1).cgColor
        layer.borderWidth = 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds.inset(by: peekInset)
    }
    
    override func draw(_ rect: CGRect) {
        if let backgroundImage = self.backGroundImage {
            backgroundImage.draw(in: bounds)
        }
        
        super.draw(rect)
        
        if let shadowImage = self.shadowImage {
            shadowImage.draw(in: bounds)
        }
        
        if let glassImage = self.glassImage,showGlass==true {
            glassImage.draw(in: CGRect(x: frame.width / 2 - 30, y: 0, width: 60, height: frame.height))
        }
    }
    
    
    private func scrollToIndex(index:Int, animated:Bool){
        
        let scrollOffset = contentView.frame.width * CGFloat(index)
        contentView.setContentOffset(CGPoint(x: scrollOffset, y: 0), animated: animated)
    }
    
   func setSelectedItem(selectedItem:Int,animated:Bool){
        scrollToIndex(index: selectedItem, animated: animated)
        delegate?.pickerView_didSelectItem(pickerView: self, item: selectedItem)
    }
    
    
    //MARK:-Touch handling
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event){
            return contentView
        }
        return nil
    }
    
    //Mark: - Data handling and interaction
    func reloadData(){
        selectedItem=0
        itemCount=0
        for view in visibleViews{
            if let aView = view as? UIView {
                aView.removeFromSuperview()
            }
        }
        for view in recycledViews{
            if let aView = view as? UIView {
                aView.removeFromSuperview()
            }
        }
    
        visibleViews.removeAllObjects()
        recycledViews.removeAllObjects()
        
        if let itemCount=dataSource?.numberOfItemsInPickerView(horizontalPickerView: self){
               self.itemCount=itemCount
        }else{
            self.itemCount=0
        }
        
        scrollToIndex(index: 0, animated: false)
        contentView.frame = bounds.inset(by: peekInset)
        contentView.contentSize = CGSize(width: contentView.frame.width * CGFloat(itemCount), height: contentView.frame.height)
        
        tileViews()
    }
    
    private func determineCurrentItem(){
        let delta = contentView.contentOffset.x
        let position:Int = Int(round(delta  / contentView.frame.width))
        selectedItem = position
        delegate?.pickerView_didSelectItem(pickerView: self, item: selectedItem)
    }
    
    
    //Mark: - recycle queue
    func dequeueRecycledView()->UIView?{
        guard let view = recycledViews.anyObject() as? UIView else {return nil}
        recycledViews.remove(view)
         return view
    }
    
    func isDisplayingViewForIndex(index:Int)->Bool{
        var foundPage=false
        for view in visibleViews{
            if let aView = view as? UIView{
                let viewIndex = aView.frame.origin.x / contentView.frame.width
                if viewIndex == CGFloat(index){
                   foundPage=true
                    break
                }
            }
        }
        return foundPage
    }

    private func tileViews(){
        let visibleBounds = contentView.bounds
        let currentViewIndex:Int = Int(floor(contentView.contentOffset.x / contentView.frame.width))
        var firstNeededViewIndex = currentViewIndex - 2
        var lastNeededViewIndex = currentViewIndex + 2
        firstNeededViewIndex = max(firstNeededViewIndex,0)
        lastNeededViewIndex = min(lastNeededViewIndex, self.itemCount - 1)
        
        // Recycle no-longer-visible pages
        for view in visibleViews{
            let viewIndex = (view as! UIView).frame.origin.x / visibleBounds.width - CGFloat(2)
            if viewIndex < CGFloat(firstNeededViewIndex) || viewIndex > CGFloat(lastNeededViewIndex){
                recycledViews .add(view)
                (view as! UIView).removeFromSuperview()
            }
        }
        visibleViews.minus(recycledViews as! Set<AnyHashable>)
        
        for index in firstNeededViewIndex ..< lastNeededViewIndex+1{
            if !isDisplayingViewForIndex(index: index){
                var label = dequeueRecycledView() as? UILabel
                if label==nil{
                    label = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height))
                    label?.backgroundColor = UIColor.clear
                    label?.font = itemFont
                    label?.textColor = itemColor
                    label?.textAlignment = .center
                }
                configureView(view: label!, atIndex: index)
                contentView.addSubview(label!)
                visibleViews.add(label)
            }
        }
    }
    
    func configureView(view:UIView, atIndex index:Int){
        guard let label = view as? UILabel,let text=dataSource?.titleforItemInPickerView(horizontalPickerView: self, forItem: index) else{return}
           
        label.text=text
        var frame = label.frame
        frame.origin.x = contentView.frame.width * CGFloat(index)
        label.frame = frame
        
    }
}


extension HorizontalPickerView{
    //Mark: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tileViews()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        determineCurrentItem()
        
        if !contentView.isPagingEnabled {
            scrollToIndex(index: selectedItem, animated: true)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        contentView.isPagingEnabled = true
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        if velocity.x > constPickerDecelerationThreshold && allowSlowDeceleration==true{
            contentView.isPagingEnabled = false
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.pickerView_willBeginChangeItem(pickerView: self)
    }
}
