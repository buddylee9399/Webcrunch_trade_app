# Ruby on Rails #56 Generate QR codes, Barcodes, use ServiceObjects

- https://www.youtube.com/watch?v=2AG-JR_zbSU
- https://github.com/corsego/56-qrcode-barcode-serviceobject/commit/340e12e7a1e58a5f22a2935cbfc33e6420327262
- good random tool to decode barcodes and qrcodes: 
- https://zxing.org/w/decode.jspx
- bundle add rqrcode
- rails c, to test if it works

```
require "rqrcode"

qr = RQRCode::QRCode.new("https://kyan.com")

puts qr.to_s
# to_s( dark: "x", light: " " ) # defaults
```

- SAVING AS IMAGE
- bundle add chunky_png
- rails active_storage:install
- rails db:migrate
- update post.rb

```
  include Rails.application.routes.url_helpers

  after_create :generate_qr
  def generate_qr
    url_for(controller: 'posts',
            action: 'show',
            id: self.id,
            only_path: false,
            host: 'superails.com',
            source: 'from_qr'
            )
  end
```

- update post/index

```
...
      <th scope="col">QR Code</th>
...
        <td><%= post.generate_qr %></td>      
```

- refresh index page we should see

```
http://superails.com/posts/51?source=from_qr
```

- update the post.rb

```
  include Rails.application.routes.url_helpers
  require "rqrcode"
  after_create :generate_qr
  def generate_qr
   qr_url = url_for(controller: 'posts',
            action: 'show',
            id: self.id,
            only_path: false,
            host: 'superails.com',
            source: 'from_qr'
            )
    qrcode = RQRCode::QRCode.new(qr_url)    
  end
```

- refresh the post/index and we should see qrcode
- update with the png

```
  def generate_qr
   qr_url = url_for(controller: 'posts',
            action: 'show',
            id: self.id,
            only_path: false,
            host: 'superails.com',
            source: 'from_qr'
            )
    qrcode = RQRCode::QRCode.new(qr_url)    

    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 120
    )
  end
```

- to generate an image to the tmp folder

```
  def generate_qr
   qr_url = url_for(controller: 'posts',
            action: 'show',
            id: self.id,
            only_path: false,
            host: 'superails.com',
            source: 'from_qr'
            )
    qrcode = RQRCode::QRCode.new(qr_url)    

    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 120
    )
    image_name = SecureRandom.hex
    IO.binwrite("tmp/#{image_name}.png", png.to_s)
  end
```

- IT WORKED
- SAVING IT TO ACTIVE STORAGE AND ASSIGING IT TO EACH POST
- update post.rb

```
  has_one_attached :qr_code
  include Rails.application.routes.url_helpers
  require "rqrcode"
  after_create :generate_qr
  def generate_qr
   qr_url = url_for(controller: 'posts',
            action: 'show',
            id: self.id,
            only_path: false,
            host: 'superails.com',
            source: 'from_qr'
            )
    qrcode = RQRCode::QRCode.new(qr_url)    

    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 120
    )
    image_name = SecureRandom.hex
    IO.binwrite("tmp/#{image_name}.png", png.to_s)

    blob = ActiveStorage::Blob.create_and_upload!(
      io: File.open("tmp/#{image_name}.png"),
      filename: image_name,
      content_type: 'png'
    )

    self.qr_code.attach(blob)    
  end
```

- i had to update cuz of bullet posts controller index action

```
@pagy, @posts = pagy(Post.order(created_at: :desc).includes([:user, :qr_code_attachment]))
```

- update post index

```
<td><%= image_tag(post.qr_code) if post.qr_code.attached? %></td>
```

- create a new post, it should work
- TURNING IT INTO A SERVICE SO ITS NOT IN POST.RB
- in terminal: mkdir app/services
- create app/services/application_service.rb

```
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
```

- create app/services/generate_qr.rb

```
class GenerateQr < ApplicationService
  attr_reader :post

  def initialize(post)
    @post = post
  end

  include Rails.application.routes.url_helpers

  require "rqrcode"

  def call
    qr_url = url_for(controller: 'posts',
            action: 'show',
            id: post.id,
            only_path: false,
            host: 'superails.com',
            protocol: 'https',
            source: 'from_qr'
            )

    qrcode = RQRCode::QRCode.new(qr_url)

    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 120
    )

    image_name = SecureRandom.hex

    IO.binwrite("tmp/#{image_name}.png", png.to_s)

    blob = ActiveStorage::Blob.create_and_upload!(
      io: File.open("tmp/#{image_name}.png"),
      filename: image_name,
      content_type: 'png'
    )

    post.qr_code.attach(blob)
  end
end
```

- update post.rb

```
  has_one_attached :qr_code
  after_create :generate_qr
  def generate_qr
    GenerateQr.call(self)
  end
```

- refresh and create a new post
- IT WORKED
- DOING BARCODES
- bundle add barby
- https://github.com/toretore/barby
- update post.rb

```
  has_one_attached :qr_code
  has_one_attached :barcode
  after_create :generate_qr
  def generate_qr
    GenerateQr.call(self)
    GenerateBarcode.call(self)    
  end
```

- create app/services/generate_barcode.rb

```
class GenerateBarcode < ApplicationService
  attr_reader :post

  def initialize(post)
    @post = post
  end

  require 'barby'
  require 'barby/barcode/code_128'
  require 'barby/outputter/ascii_outputter'
  require 'barby/outputter/png_outputter'

  def call
    barcode = Barby::Code128B.new(post.title)

    png = Barby::PngOutputter.new(barcode).to_png

    image_name = SecureRandom.hex

    IO.binwrite("tmp/#{image_name}.png", png.to_s)

    blob = ActiveStorage::Blob.create_and_upload!(
      io: File.open("tmp/#{image_name}.png"),
      filename: image_name,
      content_type: 'png'
    )

    post.barcode.attach(blob)
  end
end
```

- refresh and create a post
- IT WORKED
