let html who =
  let open Dream_html in
  let open HTML in
  html
    [ lang "en" ]
    [
      head [] [ title [] "Greeting" ];
      comment "Embedded in the HTML";
      body [] [ h1 [] [ txt "Good morning, %s!" who ] ];
    ]
