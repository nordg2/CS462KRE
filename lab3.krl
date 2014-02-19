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
        pre {
            stuff = <<
                <form id=myForm" onsubmit='return false'>
                    <table>
                        <tr>
                            <td>
                                First Name:
                            </td>
                            <td>
                                <input name="first"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Last Name:
                            </td>
                            <td>
                                <input name="last"/>
                            </td>
                        </tr>
                    </table>
                    <input type="submit" value="Submit">
                </form>
                >>;
        }
        if(not ent:username) then {
            replace_html("#main",stuff);
            watch("#myForm", "submit");
        }
    }
    rule respond_submit {
        select when web submit "#myForm"
        pre{
            username = event:attr("first")+" "+event:attr("last");
        }
        replace_inner("#myDiv", "Hello #{username}");
        fired {
            set ent:username username;
        }
    }
    
    
}
