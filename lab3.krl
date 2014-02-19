ruleset alert {
    meta {
        name "notify example"
        author "BJ Nordgren"
        logging off
    }
    dispatch {
         //domain "exampley.com"
    }
    rule show_form {
        select when pageview ".*" setting ()
        stuff = << <div id='iwin'><h2>This is my text</h2></div> >>;
        replace_html("#main",stuff);
    }
}
