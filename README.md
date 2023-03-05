Steps (Assuming Docker is installed on your machine)
- git clone https://github.com/mbootland/web_fetcher.git
- cd web_fetcher/
- rm -rf output (Only if you have run the script before and the output folder exist)
- docker build -t fetcher .
- docker run --cpus=2 --memory=4g -v "$(pwd)/output:/app/output" fetcher
- Output folder is created inside current directory (web_fetcher)

Scope of completed work:
- Section 1 + 2 and bonus

Approach
- Ruby with Nokogiri for parsing HTML
- Retrieve metadata print it to terminal and save it to *.metadata in the output folder e.g. web_fetcher/output/www.google.com.metadata
- Save images to the assets folder (e.g. web_fetcher/output/assets/01_unity.svg)
- Modify the saved html files to reference the locally stored assets e.g. 'assets/12_radar.svg' and save them to the output folder e.g. output/www.google.com.html

Limitations(due to time):
- I have only tested the script on https://www.google.com and https://autify.com/
- Only 'img, picture source, noscript img' are supported
- img type 'source' can contain many images in 1 string, but they are being counted as only 1 currently. Looping through them would solve that problem. So the count is definitely lower than it should be for autify.com if you are counting actual images and not image reference strings
- If the CSS for an image includes a transition, I remove it as well as the opacity, this unhides images that would be displayed by a transition. Things unhidden by Javascript etc will not be unhidden with the hacky solution

My original implementation used the 'selenium-webdriver' gem and I made a headless chrome browser wait for 3 seconds (autify.com uses 500ms but just to be generic I gave 3s) before running my script. However, I spent too long trying to get this to work inside docker, so I moved on.
- I dump all assets into a single assets folder. This is suboptimal as two assets from different websites could name clash causing a bug. I would create a seperate directory for each website if I had more time e.g. assets/google assets/autify
- Possible HTML/CSS parsing errors due to my implementation not being generic. With more time I would test more websites.
- Not rubocop compliant. Rubocop compliancy in the latest versions actually makes the code incompatible with older Ruby versions (e.g. the 'num_links:,' syntax short for 'num_links: num_links,')