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
        stuff = << <div id='main'>This is my text</div> >>;
        replace_html("#main",stuff);
    }
}
