import Foundation


extension Page {
    
    class func pagesWithJson(json: [[String: AnyObject]], inContext context: NSManagedObjectContext) -> [Page] {
        return json
            .sort { Int($0["id"] as! String)! < Int($1["id"] as! String)! }
            .map { pageWithJson($0, inContext: context) }
    }
    
    class func pageWithJson(json: [String: AnyObject], inContext context: NSManagedObjectContext) -> Page {
        let identifier = json["id"] as! String
        
        if let page = Page.findPageWithIdentifier(identifier, inContext: context) {
            updatePage(page, withJson: json)
            return page
        }
        else {
            let page = NSEntityDescription.insertNewObjectForEntityForName("Page", inManagedObjectContext: context)
                as! Page
            page.identifier = identifier
            updatePage(page, withJson: json)
            return page
        }
    }
    
    class func updatePage(page: Page, withJson json: [String: AnyObject]) {
        page.excerpt = json["excerpt"] as? String
        page.content = json["content"] as? String
        page.title = json["title"] as? String
        page.order = json["order"] as? String
        page.parentPage = (json["parent"] as? String).flatMap { parentId in
            if (parentId == "0") { return nil; }
            return Page.findPageWithIdentifier(parentId, inContext: page.managedObjectContext!)
        }
    }
    
}
