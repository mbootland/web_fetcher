FROM selenium/standalone-chrome

USER root
RUN apt-get update && apt-get install -y ruby

# Install the required gems
RUN gem install nokogiri selenium-webdriver httpclient

# Set the working directory
WORKDIR /app

# Mount a volume that points to the output directory on the local machine
VOLUME ["/app/output"]

# Copy the fetch.rb script to the container
COPY ./fetch.rb ./fetch.rb

# Run the Fetch.rb script and move generated files and assets to directory containing Dockerfile
CMD ["sh", "-c", "ruby fetch.rb https://www.google.com https://autify.com/ && mv *.html *.metadata assets /app/output"]
