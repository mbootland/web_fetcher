Steps (Assuming Docker is installed on your machine)
- git clone https://github.com/mbootland/web_fetcher.git
- cd web_fetcher/
- docker build -t fetcher .
- docker run -v "$(pwd)/output:/app/output" fetcher

Notes: 
- Please delete the output folder before re-running the docker run command

Scope of completed work:
- Section 1 + 2 and bonus

Approach
- Ruby with Nokogiri for parsing HTML
- Retrieve metadata print it to terminal and save it to *.metadata in the output folder e.g. web_fetcher/output/www.google.com.metadata
- Save images to the assets folder (e.g. web_fetcher/output/assets/01_unity.svg)
- Modify the saved html files to reference the locally stored assets e.g. 'assets/12_radar.svg' and save them to the output folder e.g. output/www.google.com.html
- Headless browser used to allow css transitions and JavaScript to run without hacks

Limitations(due to time):
- I have only tested the script on https://www.google.com and https://autify.com/
- Only 'img, picture source, noscript img' are supported
- img type 'source' can contain many images in 1 string, I'm counting them as 1 currently. If this is incorrect could loop
- Headless browsers have some quirks e.g. there is a widget that displays a connection failure to connect on Google, this isn't present when I view it via my browser.
- I dump all assets into a single assets folder. This is suboptimal as two assets from different websites could name clash causing a bug. I would create a seperate directory for each website if I had more time e.g. assets/google assets/autify
- Possible HTML/CSS parsing errors due to my implementation not being generic. With more time I would test more websites.
- Not rubocop compliant. Rubocop compliancy in the latest versions actually makes the code incompatible with older Ruby versions (e.g. the 'num_links:,' syntax short for 'num_links: num_links,'). Cyclomatic complexity is also too high. So I have Rubocop compliancy for now. 