ruleset alert {
    meta {
        name "notify example"
        author "BJ Nordgren"
        logging off
    }
    dispatch {
         //domain "exampley.com"
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
            notify("Hello", a[1] || "Hello Monkey") with position = 'bottom-left';
 
    }
    rule third_rule {
        select when pageview ".*" setting () 
        pre {
            x = app:visitor_count || 1;
        }
        if(x <= 5) then
            notify("Count", x || "fail")  with position = 'bottom-right';
        

        always {
            app:visitor_count += 1 from 1;
        }
    }
    rule fourth_rule {
        select when pageview ".*" setting()
          
        pre {
            query1 = page:url("query");
            a1 = query1.extract(re/(clear([^&]*))/);
        }
       if a1[0] neq "" then
             notify("Cleared","")
        fired {
             set app:visitor_count 1;
        }  else {
            set app:visitor_count 3;
        } 
    }
}









