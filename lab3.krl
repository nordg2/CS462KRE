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
                <form id=myForm">
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
        
        replace_html("#main",stuff);
        watch("#myForm", "submit");
    }
    
    
}
