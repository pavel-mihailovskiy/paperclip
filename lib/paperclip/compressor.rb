# encoding: utf-8

module Paperclip
  class Compressor
    attr_reader :uploaded_file, :options, :path

    TOOL_NAMES = { :imagealpha => 'image-alpha',
                   :jpegmini   => 'jpeg-mini' }

    def initialize(uploaded_file, options)
      @uploaded_file = uploaded_file
      @options       = options
    end

    def perform!
      write_temp_file!
      compress!
      File.open(file_path)
    end

    private

    # Example:
    # imageoptim --image-alpha --jpeg-mini --quit --directory ~/Sites/MyProject
    def compress!
      command = TOOL_NAMES.inject('imageoptim') do |command, (name, param)|
        if options[:tools][name]
          command = "#{command} --#{param}"
        end
        command
      end
      result = system "#{command} --quit #{directory_parameter}"
      raise "File compression error." unless result
    end

    def directory_parameter
      "--directory #{directory}"
    end

    def directory
      return path if path
      dir = "#{Rails.root}/public/#{options[:temp_storage] || 'temp_images_storage'}"
      File.directory?(dir) ? dir : FileUtils.mkpath(dir).first
    end

    def write_temp_file!
      data = uploaded_file.read
      File.open(file_path, 'wb') { |f| f.write(data) }
    end

    def file_path
      @file_path ||= "#{directory}/#{uploaded_file.original_filename}"
    end

    def remove_temp_file!
      File.delete(file_path)
    end
  end
end
