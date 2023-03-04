# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'date'
require 'yaml'
require 'uri'

class WebPageFetcher
  def self.fetch(urls)
    urls.each do |url|
      begin
        doc = Nokogiri::HTML(URI.open(url))

        # Save the web page to disk
        filename = "#{URI(url).host}.html"
        File.open(filename, 'w') do |file|
          file.write(fix_image_urls(doc, url).to_html)
        end

        # Set metadata
        num_links = doc.css('a').count
        num_images = doc.css('img, picture source, noscript img').count
        last_fetch = DateTime.now

        metadata = {
          site: URI(url).host,
          num_links: num_links,
          num_images: num_images,
          last_fetch: last_fetch.to_s
        }

        # Save metadata to disk
        File.open("#{URI(url).host}.metadata", 'w') do |file|
          file.write(metadata.to_yaml)
        end

        puts '---'
        puts "Metadata for #{url}:"
        puts "site: #{metadata[:site]}"
        puts "num_links: #{metadata[:num_links]}"
        puts "num_images: #{metadata[:num_images]}"
        puts "last_fetch: #{metadata[:last_fetch]}"
      rescue StandardError => e
        puts "Error while fetching #{url}: #{e.message}"
      end
    end
  end

  def self.fix_image_urls(doc, url)
    # Replace relative image URLs with absolute paths
    base_url = URI(url)

    # Support these image types (tested on google.com and autify.com)
    doc.css('img, picture source, noscript img').each do |img|
      if img.name == 'img'
        img_src = img['src']
        if img_src
          img_url = URI(img_src)
          if img_url.relative?
            # Extract the filename from the image URL
            img_filename = File.basename(img_url.path)
            # Set the image's src attribute to the filename in the assets folder
            img['src'] = "assets/#{img_filename}"
            # Download the image to the assets folder
            download_asset(base_url.merge(img_url), img_filename)
            # Replace all occurrences of the original image URL with the new asset folder path
            doc.to_s.gsub!(img_src, "assets/#{img_filename}")
          end
        end

        # If srcset is present, change it to be equal to src (e.g. Google Logo)
        img['srcset'] = img['src'] unless img['srcset']
      elsif img.name == 'source'
        img_srcset = img['srcset']
        # Many URIs will be present in a single string, therefore must loop.
        img_srcset.split(',').each do |srcset|
          srcset_url = URI(srcset.strip.split(' ').first)
          next unless srcset_url.relative?

          # Extract the filename from the image URL
          img_filename = File.basename(srcset_url.path)
          # Replace the srcset attribute value with the filename only
          img['srcset'] = img['srcset'].sub(srcset, "assets/#{img_filename} #{srcset.strip.split(' ')[1]}")
          # Download the image to the assets folder
          download_asset(base_url.merge(srcset_url), img_filename)
        end
      end
      
      # If the css includes a transition, remove it and the opacity.
      if img['style']&.include?('transition')
        img['style'] = img['style']
          .gsub(/transition:.+?;/, '')
          .gsub(/opacity:\s*0(;|$)/, '')
      end
    end

    doc
  end

  def self.download_asset(url, filename)
    assets_dir = 'assets'
    
    Dir.mkdir(assets_dir) unless File.directory?(assets_dir)
    File.open("#{assets_dir}/#{filename}", 'wb') do |file|
      file.write(URI.open(url).read)
    end
  end
end

WebPageFetcher.fetch(ARGV)
