Steps
- docker build -t fetcher .
- docker run -v "$(pwd)/output:/app/output" fetcher
- Generated content appears in the output folder