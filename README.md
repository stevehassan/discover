# discover
Angular Dublin Core data repository explorer with harvester.

This app requires a web server to run.

1. Optionally run OAIHarvester.java to fetch the full repository from the UK Data Service OAO Feed.
2. For Facebook login to work, replace Facebook ```app_id``` with yours in index.html:

  ```html
  <meta property="fb:app_id" content="123456789876543" />
  ```

3. Also modify your ```og:``` meta properties, e.g.

  ```html
  <meta property="og:url" content="http://localhost:8080" />
  ```

4. Finally replace Facebook AppId with yours in controllers.js and re-minify:

  ```javascript
  $facebookProvider.setAppId('123456789876543')
  ``` 
