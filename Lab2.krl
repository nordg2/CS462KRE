ruleset alert {
    meta {
        name "notify example"
        author "BJ Nordgren"
        logging off
    }
    dispatch {
        // domain "exampley.com"
    }
    rule first_rule every{
        select when pageview ".*" setting ()
        // Display notification that will not fade.
        notify("Notify 1", "This is my first notify!") with sticky = false;
        notify("Notify 2", "This is my second notify!") with position = 'top-left';
       
    }
}
