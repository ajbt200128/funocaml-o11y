let html request =
  let open Dream_html in
  let open HTML in
  let session_id = Dream.session_id request in
  Dream.log "Greeting requested for session %s" session_id;
  html
    [ lang "en" ]
    [
      head [] [ title [] "Greeting" ];
      comment "Embedded in the HTML";
      body [] [ h2 [] [ txt "Good morning, %s!" session_id ] ];
    ]
