ruleset alert {
    meta {
        name "notify example"
        author "BJ Nordgren"
        logging off
    }
    dispatch {
        // domain "exampley.com"
    }
    rule first_rule {
        select when pageview ".*" setting ()
        // Display notification that will not fade.
        every{
            notify("Notify 1", "This is my first notify!") with sticky = false and position = 'top-left';
            notify("Notify 2", "This is my second notify!") with position = 'top-right';
        }
    }
    rule second_rule {
    
        select when pageview ".*" setting ()
        pre {
            query = page:url("query");
            a = query.extract(re/(name=([^&]*))/);
        }
            notify("Hello", a[0] || "Hello Monkey") with position = 'bottom-left';
 
    }
    rule third_rule{
        select when repeat 5 (pageview)
        notify("Count", "count amount");
    }
}
















