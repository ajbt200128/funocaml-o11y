let html =
  let open Dream_html in
  let open HTML in
  html
    [ lang "en" ]
    [
      head [] [ title [] "Homepage" ];
      body []
        [
          h1 [] [ txt "Welcome to the Funocaml O11y example!" ];
          a [ href "/chat" ] [ txt "Go to chat" ];
          br [];
          a [ href "/greet" ] [ txt "Go to greeting" ];
          br [];
          a [ href "/long" ] [ txt "Go to long running computation" ];
          br [];
          a [ href "/error" ] [ txt "Go to error" ];
          br [];
        ];
    ]
