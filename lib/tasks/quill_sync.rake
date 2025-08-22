# Rake task to vendor-sync Quill assets from upstream (jsDelivr CDN)
# Usage:
#   bundle exec rake quill:sync[2.0.3]
#   (omit version to use default)
#
# This will download the following files from jsDelivr and place them under app/assets:
#   - javascripts/quill.js        (saved as quill.core.js)
#   - javascripts/quill.min.js
#   - stylesheets/quill.core.css
#   - stylesheets/quill.snow.css
#   - stylesheets/quill.bubble.css
#
# Note: This task requires network access. It is not invoked by tests.

require 'net/http'
require 'uri'
require 'fileutils'

namespace :quill do
  desc 'Sync Quill assets from jsDelivr (default version: 2.0.3). Example: rake quill:sync[2.0.3]'
  task :sync, [:version] do |t, args|
    version = args[:version] || '2.0.3'

    base = "https://cdn.jsdelivr.net/npm/quill@#{version}/dist"

    targets = [
      { url: "#{base}/quill.js",        path: 'app/assets/javascripts/quill.core.js' },
      { url: "#{base}/quill.min.js",    path: 'app/assets/javascripts/quill.min.js' },
      { url: "#{base}/quill.core.css",  path: 'app/assets/stylesheets/quill.core.css' },
      { url: "#{base}/quill.snow.css",  path: 'app/assets/stylesheets/quill.snow.css' },
      { url: "#{base}/quill.bubble.css",path: 'app/assets/stylesheets/quill.bubble.css' }
    ]

    def download_to(url_str, dest_path)
      uri = URI.parse(url_str)
      puts "Downloading: #{uri} -> #{dest_path}"
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        req = Net::HTTP::Get.new(uri.request_uri)
        http.request(req) do |res|
          unless res.is_a?(Net::HTTPSuccess)
            raise "Failed to download #{uri}: #{res.code} #{res.message}"
          end
          FileUtils.mkdir_p(File.dirname(dest_path))
          File.open(dest_path, 'wb') do |file|
            res.read_body { |chunk| file.write(chunk) }
          end
        end
      end
    end

    targets.each do |entry|
      download_to(entry[:url], entry[:path])
    end

    puts "Quill assets synced for version #{version}."
  end
end
