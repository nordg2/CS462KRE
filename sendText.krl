ruleset location_data {
  meta {
    name "lab 6"
    description <<
      send a twillio location text
    >>
    author "BJ Nordgren"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
    key twilio {"account_sid" : "AC41296657fe2c0daad065ecf124973366",
                    "auth_token"  : "0b233e07bb712fdc8e67574cc5d9b3"
        }
         
        use module a8x115 alias twilio with twiliokeys = keys:twilio()

  }
  dispatch {
  }
  global{
  
  }

  rule location_nearby {
    select when explicit location_nearby
    

    {
      send_directive("location is near");
      twilio:send_sms("8014001952", "3852194405", "nearby!");
    }
  }
  
  rule location_far {
    select when explicit location_far
    {
      send_directive("location is far");
      twilio:send_sms("8014001952", "3852194405", "far far away!");
    }
  }
  
}