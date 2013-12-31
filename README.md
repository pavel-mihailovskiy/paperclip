Integrated Paperclip with ImageOptim-CLI
(http://www.smashingmagazine.com/2013/12/17/imageoptim-cli-batch-compression-tool/)

Configs example:
```ruby
  has_attached_file :variant,
    :styles => {
      :small => '175x250#', :big => '420x250#'
    },
    :path => "#{::Rails.root}/public/system/:attachment/:id/:style/:basename.:extension",
    :compress => {
      :temp_storage => 'temp_images_storage',
      :tools => {
        :imagealpha => true,
        :jpegmini   => false
      }
    }
```

An example Rails initializer would look something like this:
```ruby
  Paperclip::Attachment.default_options[:compress] = {
    :temp_storage => 'temp_images_storage',
    :tools => {
      :imagealpha => true,
      :jpegmini   => false
    }
  }
```
