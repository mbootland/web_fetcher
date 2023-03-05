# Using this image as I am using selenium with Chrome headless
FROM selenium/standalone-chrome

# Set the user as root (permission denied errors without this)
USER root

# Install Ruby
RUN apt-get update && apt-get install -y ruby

# Install Ruby gems
RUN gem install nokogiri selenium-webdriver

# Set the working directory
WORKDIR /app

# Mount a volume that points to the output directory on the local machine
VOLUME ["/app/output"]

# Copy the fetch.rb script to the container
COPY ./fetch.rb ./fetch.rb

# Run the fetch.rb script and move the generated files to the output directory outside of the container
CMD ["sh", "-c", "ruby fetch.rb https://www.google.com https://autify.com/ && mv *.html *.metadata assets /app/output"]
