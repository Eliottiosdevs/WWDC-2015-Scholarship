//
//  AchievementTableViewCell.swift
//  PatrickBalestra
//
//  Created by Patrick Balestra on 02/02/15.
//  Copyright (c) 2015 Patrick Balestra. All rights reserved.
//

import UIKit

class AchievementTableViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var pageViews = [Int : UIImageView]()
    var pagesCount: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.isScrollEnabled = true
        scrollView.delegate = self
        pageControl.currentPage = 0
    }
    
    var achievement :Achievement? {
        didSet {
            
            titleLabel.text = achievement?.title
            descriptionLabel.text = achievement?.description

            scrollView.contentSize = CGSize(width: CGFloat(achievement?.images.count ?? 0) * 768.0, height: 500)
            pageControl.numberOfPages = achievement?.images.count ?? 0
            pagesCount = achievement?.images.count ?? 0

            self.layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        
        // Clear the already stored images
        pageViews.removeAll(keepingCapacity: true)
        
        // Load pages
        if pagesCount > 0 {
            scrollView.contentSize = CGSize(width: CGFloat(achievement?.images.count ?? 0) * 768.0, height: 500)
            loadVisiblePages()
        }
        
    }
    
    func loadVisiblePages() {
        // Calculate which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        pageControl.currentPage = page
        
        let firstPage = page - 1
        let lastPage = page + 1
        
        if firstPage < 0 {
            for i in firstPage..<0 {
                //for var index = 0; index < firstPage; ++index {
                purgePage(i)
            }
        } else {
            for i in 0..<firstPage {
                //for var index = 0; index < firstPage; ++index {
                purgePage(i)
            }
        }
        
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        for i in 0..<achievement!.images.count {
//        for var index = lastPage+1; index < achievement?.images.count; ++index {
            purgePage(i)
        }
    }
    
    func loadPage(_ page: Int) {
        if page < 0 || page >= (achievement?.images.count)! {
            return
        }
        
        if pageViews[page] == nil {
            
            //let image = UIImage(named: achievement?.images[page] ?? "")!
            //let width = (500 / image.size.height) * image.size.width
            var frame = CGRect.zero
            frame.origin.x = 768 * CGFloat(page)
            frame.origin.y = 0.0
            frame.size.width = 768
            frame.size.height = 500

            let newPageView = UIImageView(image: UIImage(named: (achievement?.images[page])!))
            newPageView.contentMode = .scaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(_ page: Int) {
        if page < 0 || page >= (achievement?.images.count)! {
            return
        }
        
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews.removeValue(forKey: page)
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadVisiblePages()
    }

}
