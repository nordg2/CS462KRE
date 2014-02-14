Copy and paste your KRL into the box below

The KRL must be in the form of a ruleset, not just a rule.


Flavor:  

Congratulations! Your ruleset passed

The JSON for the above ruleset is:

{
   "dispatch" : [],
   "global" : [],
   "ruleset_name" : "alert",
   "rules" : [
      {
         "cond" : {
            "type" : "bool",
            "val" : "true"
         },
         "actions" : [
            {
               "action" : {
                  "source" : null,
                  "name" : "notify",
                  "args" : [
                     {
                        "type" : "str",
                        "val" : "Notify 1"
                     },
                     {
                        "type" : "str",
                        "val" : "This is my first notify!"
                     }
                  ],
                  "modifiers" : [
                     {
                        "value" : {
                           "type" : "bool",
                           "val" : "false"
                        },
                        "name" : "sticky"
                     },
                     {
                        "value" : {
                           "type" : "str",
                           "val" : "top-left"
                        },
                        "name" : "position"
                     }
                  ],
                  "vars" : null
               },
               "label" : null
            },
            {
               "action" : {
                  "source" : null,
                  "name" : "notify",
                  "args" : [
                     {
                        "type" : "str",
                        "val" : "Notify 2"
                     },
                     {
                        "type" : "str",
                        "val" : "This is my second notify!"
                     }
                  ],
                  "modifiers" : [
                     {
                        "value" : {
                           "type" : "str",
                           "val" : "top-right"
                        },
                        "name" : "position"
                     }
                  ],
                  "vars" : null
               },
               "label" : null
            }
         ],
         "blocktype" : "every",
         "name" : "first_rule",
         "pre" : [],
         "post" : null,
         "state" : null,
         "emit" : null,
         "callbacks" : null,
         "pagetype" : {
            "event_expr" : {
               "domain" : "web",
               "filters" : [
                  {
                     "pattern" : ".*",
                     "type" : "default"
                  }
               ],
               "type" : "prim_event",
               "vars" : [],
               "op" : "pageview"
            },
            "foreach" : []
         }
      },
      {
         "cond" : {
            "type" : "bool",
            "val" : "true"
         },
         "actions" : [
            {
               "action" : {
                  "source" : null,
                  "name" : "notify",
                  "args" : [
                     {
                        "type" : "str",
                        "val" : "Hello"
                     },
                     {
                        "args" : [
                           {
                              "type" : "array_ref",
                              "val" : {
                                 "index" : {
                                    "type" : "num",
                                    "val" : 1
                                 },
                                 "var_expr" : "a"
                              }
                           },
                           {
                              "type" : "str",
                              "val" : "Hello Monkey"
                           }
                        ],
                        "type" : "pred",
                        "op" : "||"
                     }
                  ],
                  "modifiers" : [
                     {
                        "value" : {
                           "type" : "str",
                           "val" : "bottom-left"
                        },
                        "name" : "position"
                     }
                  ],
                  "vars" : null
               },
               "label" : null
            }
         ],
         "blocktype" : "every",
         "name" : "second_rule",
         "pre" : [
            {
               "lhs" : "query",
               "rhs" : {
                  "source" : "page",
                  "predicate" : "url",
                  "args" : [
                     {
                        "type" : "str",
                        "val" : "query"
                     }
                  ],
                  "type" : "qualified"
               },
               "type" : "expr"
            },
            {
               "lhs" : "a",
               "rhs" : {
                  "obj" : {
                     "type" : "var",
                     "val" : "query"
                  },
                  "name" : "extract",
                  "args" : [
                     {
                        "type" : "regexp",
                        "val" : "/(name=([^&]*))/"
                     }
                  ],
                  "type" : "operator"
               },
               "type" : "expr"
            }
         ],
         "post" : null,
         "state" : null,
         "emit" : null,
         "callbacks" : null,
         "pagetype" : {
            "event_expr" : {
               "domain" : "web",
               "filters" : [
                  {
                     "pattern" : ".*",
                     "type" : "default"
                  }
               ],
               "type" : "prim_event",
               "vars" : [],
               "op" : "pageview"
            },
            "foreach" : []
         }
      },
      {
         "cond" : {
            "args" : [
               {
                  "type" : "var",
                  "val" : "x"
               },
               {
                  "type" : "num",
                  "val" : 5
               }
            ],
            "type" : "ineq",
            "op" : "<="
         },
         "actions" : [
            {
               "action" : {
                  "source" : null,
                  "name" : "notify",
                  "args" : [
                     {
                        "type" : "str",
                        "val" : "Count"
                     },
                     {
                        "args" : [
                           {
                              "type" : "var",
                              "val" : "x"
                           },
                           {
                              "type" : "str",
                              "val" : "fail"
                           }
                        ],
                        "type" : "pred",
                        "op" : "||"
                     }
                  ],
                  "modifiers" : [
                     {
                        "value" : {
                           "type" : "str",
                           "val" : "bottom-right"
                        },
                        "name" : "position"
                     }
                  ],
                  "vars" : null
               },
               "label" : null
            }
         ],
         "blocktype" : "every",
         "name" : "third_rule",
         "pre" : [
            {
               "lhs" : "x",
               "rhs" : {
                  "domain" : "app",
                  "name" : "visitor_count",
                  "type" : "persistent"
               },
               "type" : "expr"
            }
         ],
         "post" : {
            "alt" : null,
            "type" : "always",
            "cons" : [
               {
                  "domain" : "app",
                  "test" : null,
                  "from" : {
                     "type" : "num",
                     "val" : 1
                  },
                  "value" : {
                     "type" : "num",
                     "val" : 1
                  },
                  "action" : "iterator",
                  "name" : "visitor_count",
                  "type" : "persistent",
                  "op" : "+="
               }
            ]
         },
         "state" : null,
         "emit" : null,
         "callbacks" : null,
         "pagetype" : {
            "event_expr" : {
               "domain" : "web",
               "filters" : [
                  {
                     "pattern" : ".*",
                     "type" : "default"
                  }
               ],
               "type" : "prim_event",
               "vars" : [],
               "op" : "pageview"
            },
            "foreach" : []
         }
      },
      {
         "cond" : {
            "args" : [
               {
                  "type" : "array_ref",
                  "val" : {
                     "index" : {
                        "type" : "num",
                        "val" : 0
                     },
                     "var_expr" : "a1"
                  }
               },
               {
                  "type" : "str",
                  "val" : ""
               }
            ],
            "type" : "ineq",
            "op" : "neq"
         },
         "actions" : [
            {
               "action" : {
                  "source" : null,
                  "name" : "notify",
                  "args" : [
                     {
                        "type" : "str",
                        "val" : "Cleared"
                     },
                     {
                        "type" : "str",
                        "val" : ""
                     }
                  ],
                  "modifiers" : null,
                  "vars" : null
               },
               "label" : null
            }
         ],
         "blocktype" : "every",
         "name" : "fourth_rule",
         "pre" : [
            {
               "lhs" : "query1",
               "rhs" : {
                  "source" : "page",
                  "predicate" : "url",
                  "args" : [
                     {
                        "type" : "str",
                        "val" : "query"
                     }
                  ],
                  "type" : "qualified"
               },
               "type" : "expr"
            },
            {
               "lhs" : "a1",
               "rhs" : {
                  "obj" : {
                     "type" : "var",
                     "val" : "query1"
                  },
                  "name" : "extract",
                  "args" : [
                     {
                        "type" : "regexp",
                        "val" : "/(clear([^&]*))/"
                     }
                  ],
                  "type" : "operator"
               },
               "type" : "expr"
            }
         ],
         "post" : {
            "alt" : [
               {
                  "domain" : "app",
                  "test" : null,
                  "value" : {
                     "type" : "num",
                     "val" : 3
                  },
                  "action" : "set",
                  "name" : "visitor_count",
                  "type" : "persistent"
               }
            ],
            "type" : "fired",
            "cons" : [
               {
                  "domain" : "app",
                  "test" : null,
                  "value" : {
                     "type" : "num",
                     "val" : 1
                  },
                  "action" : "set",
                  "name" : "visitor_count",
                  "type" : "persistent"
               }
            ]
         },
         "state" : null,
         "emit" : null,
         "callbacks" : null,
         "pagetype" : {
            "event_expr" : {
               "domain" : "web",
               "filters" : [
                  {
                     "pattern" : ".*",
                     "type" : "default"
                  }
               ],
               "type" : "prim_event",
               "vars" : [],
               "op" : "pageview"
            },
            "foreach" : []
         }
      }
   ],
   "meta" : {
      "logging" : "off",
      "name" : "notify example",
      "author" : "BJ Nordgren"
   }
}
