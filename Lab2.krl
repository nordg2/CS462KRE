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
            notify("Notify 1", "This is my first notify!") with sticky = false and position = 'top-left;
            notify("Notify 2", "This is my second notify!") with position = 'top-right';
        }
       
    }
    rule second_rule {
    
        select when pageview ".*" setting ()
        pre{
            query = page:url("query");
        }
        if(query.match("")){
           // Display notification that will not fade.
            notify("Hello!", "Hello Monkey") with sticky = false and position = 'middle-left; 
        } else {
        // Display notification that will not fade.
            notify("Hello!", query) with sticky = false and position = 'middle-left;
        }

    }
}
